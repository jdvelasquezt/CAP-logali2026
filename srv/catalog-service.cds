// DONDE SE EXPONEN LAS ENTIDADES

using {cap_logali as CAP} from '../db/schema';
using {training as Training} from '../db/training';


service CatalogService {

    entity Products     as projection on CAP.materials.Products;
    entity Suppliers    as projection on CAP.sales.Suppliers;
    entity Suppliers_01 as projection on CAP.sales.Suppliers_01;
    entity UnitOfMeasure as projection on CAP.materials.UnitOfMeasure;
    entity Currency as projection on CAP.materials.Currencies;
    entity DimensionUnit as projection on CAP.materials.DimensionsUnits;
    entity Category as projection on CAP.materials.Categories;
    entity SalesData as projection on CAP.sales.SalesData;
    entity Reviews as projection on CAP.materials.ProductReview;
    entity Order as projection on CAP.sales.Orders;
    entity OrderItem as projection on CAP.sales.OrderItems;
    entity Month as projection on CAP.sales.Months;
}
