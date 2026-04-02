import httpStatus from 'http-status';
import { FilterQuery } from 'mongoose';
import { IProducts } from './products.interface';
import Products from './products.models';
import QueryBuilder from '../../class/builder/QueryBuilder';
import AppError from '../../error/AppError';
import { UploadedFiles } from '../../interface/common.interface';
import { uploadManyToS3 } from '../../utils/s3';

const createProducts = async (payload: IProducts, files: any) => {
  if (files) {
    const { images } = files as UploadedFiles;

    //documents
    if (images) {
      const imgsArray: { file: any; path: string; key?: string }[] = [];

      images?.map(async image => {
        imgsArray.push({
          file: image,
          path: `images/service/images`,
        });
      });

      payload.images = await uploadManyToS3(imgsArray);
    }
  }

  const result = await Products.create(payload);
  if (!result) {
    throw new AppError(httpStatus.BAD_REQUEST, 'Failed to create products');
  }
  return result;
};

const getAllProducts = async (query: Record<string, any>) => {
  const q = { ...query };

  const rawMin = q.minDiscount;
  const rawMax = q.maxDiscount;
  const rawExpiringH = q.expiringWithinHours;
  delete q.minDiscount;
  delete q.maxDiscount;
  delete q.expiringWithinHours;

  const minDiscount =
    rawMin !== undefined && rawMin !== null && rawMin !== ''
      ? Number(rawMin)
      : undefined;
  const maxDiscount =
    rawMax !== undefined && rawMax !== null && rawMax !== ''
      ? Number(rawMax)
      : undefined;

  const expiringWithinHours =
    rawExpiringH !== undefined && rawExpiringH !== null && rawExpiringH !== ''
      ? Number(rawExpiringH)
      : undefined;

  const discountRange: { $gte?: number; $lte?: number } = {};
  if (minDiscount !== undefined && !Number.isNaN(minDiscount)) {
    discountRange.$gte = minDiscount;
  }
  if (maxDiscount !== undefined && !Number.isNaN(maxDiscount)) {
    discountRange.$lte = maxDiscount;
  }

  const baseFilter: FilterQuery<IProducts> = { isDeleted: false };
  if (Object.keys(discountRange).length > 0) {
    baseFilter.discount = discountRange;
  }

  /** ISO `expiredAt` between now and now + N hours (e.g. “ending in 24h” strip). */
  if (
    expiringWithinHours !== undefined &&
    !Number.isNaN(expiringWithinHours) &&
    expiringWithinHours > 0
  ) {
    const from = new Date();
    const to = new Date(
      from.getTime() + expiringWithinHours * 60 * 60 * 1000,
    );
    baseFilter.expiredAt = {
      $gte: from.toISOString(),
      $lte: to.toISOString(),
    };
  }

  const productsModel = new QueryBuilder(
    Products.find(baseFilter).populate([
      {
        path: 'author',
        select: 'name email profile phoneNumber shop',
        populate: { path: 'shop' },
      },
      { path: 'category', select: 'name banner' },
    ]),
    q,
  )
    .search(['name'])
    .filter()
    .paginate()
    .sort()
    .fields();

  const data = await productsModel.modelQuery;
  const meta = await productsModel.countTotal();

  return {
    data,
    meta,
  };
};

const getProductsById = async (id: string) => {
  const result = await Products.findById(id).populate([
    {
      path: 'author',
      select: 'name email profile phoneNumber shop',
      populate: { path: 'shop' },
    },
    { path: 'category', select: 'name banner' },
  ]);
  if (!result || result?.isDeleted) {
    throw new Error('Products not found!');
  }
  return result;
};

const updateProducts = async (
  id: string,
  payload: Partial<IProducts>,
  files: any,
) => {
  const { images } = payload;
  if (files) {
    const { images } = files as UploadedFiles;

    //documents
    if (images) {
      const imgsArray: { file: any; path: string; key?: string }[] = [];

      images?.map(async image => {
        imgsArray.push({
          file: image,
          path: `images/service/images`,
        });
      });

      payload.images = await uploadManyToS3(imgsArray);
    }
  }

  if (images && images?.length > 0)
    images?.map(img => payload.images?.push(img));

  const result = await Products.findByIdAndUpdate(id, payload, { new: true });
  if (!result) {
    throw new Error('Failed to update Products');
  }
  return result;
};

const deleteProducts = async (id: string) => {
  const result = await Products.findByIdAndUpdate(
    id,
    { isDeleted: true },
    { new: true },
  );
  if (!result) {
    throw new AppError(httpStatus.BAD_REQUEST, 'Failed to delete products');
  }
  return result;
};

export const productsService = {
  createProducts,
  getAllProducts,
  getProductsById,
  updateProducts,
  deleteProducts,
};
