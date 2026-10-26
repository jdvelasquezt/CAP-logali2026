namespace cap_logali;

using {
    cuid, // UUID
    managed //" Managed para campos de auditoria"
} from '@sap/cds/common';


// Tipo estructura
define type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
}


//  ELEMENTOS | COLUMNAS VIRTUALES
entity Car {
    key ID                 : UUID;
        Name               : String;
        virtual Discount_1 : Decimal;
        virtual Discount_2 : Decimal;
}

// END

// CONTEXT - AGRUPAR ENTIDADES RELACIONADAS
context materials {
    entity Products : cuid { //managed {
        // key ID               : UUID;
        Name             : localized String default 'NoNAme';
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : Date;
        DiscontinuedDate : Date default $now;
        Price            : Decimal(16, 2) not null;
        Height           : type of Price; //Referenciado otra columna
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);

        // Asociacion administrada (manejada por el framework)
        Supplier         : Association to one sales.Suppliers;

        //ASociacion no administrada
        // Supplier_Id      : UUID; //Relacion """llave foranea"""
        // ToSupplier       : Association to one Suppliers
        //                        on ToSupplier.ID = Supplier_Id;

        UnitOfMeasure_Id : String(2); //Relacion """llave foranea"""
        toUnitOfMeasure  : Association to one UnitOfMeasure
                               on toUnitOfMeasure.ID = UnitOfMeasure_Id; //ASociacion no administrada

        Currency         : Association to Currencies;
        DimensionUnit    : Association to DimensionsUnits;
        Category         : Association to Categories;

        //TO MANY
        ToSalesData      : Association to many sales.SalesData
                               on ToSalesData.Product = $self;

        Reviews          : Association to many ProductReview
                               on Reviews.Product = $self;
    };

    entity Categories {
        key ID       : String(1);
            Name     : localized String;
            // enumeraciones
            Status   : Integer enum {
                Submitted = 1;
                Fulfiller = 2;
                Shipped = 3;
                Cancel = -1;
            };
            Priority : String @assert.range enum {
                high;
                medium;
                low;
            }
    // end enumeraciones
    };

    entity StockAvailability {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products;
    };

    entity Currencies {
        key ID          : String(3);
            Description : localized String;
    };

    entity UnitOfMeasure {
        key ID          : String(2);
            Description : localized String;
    };

    entity DimensionsUnits {
        key ID          : String(2);
            Description : localized String;
    };

    entity ProductReview : managed {
        key ID      : UUID;
            Name    : String;
            Rating  : Integer;
            Comment : String;
            Product : Association to Products;
    };

    // Entidad projection

    entity ProjProducts  as projection on Products;

    entity ProjProducts2 as
        projection on Products {
            Name,
            ID,
            Quantity
        };


    // Entidades de ampliación, ahora products tendrá nuevas 2 columnas y las proyecciones
    // de entidades que toman la data de proudcts también en caso de aplicar en la seleccion con *
    extend Products with {
        PriceCondition     : String(2);
        PriceDetermination : String(3);
    }

}


//COMPOSITION
// Se usa cuando hay una relación de padre-hijo: una orden o pedido, las posiciones o productos o items no pueden
// existir si no hay una orden PADRE
context sales {
    entity Orders : cuid { // El aspecto Cuid reemplaza la llave primaria ID
        // key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    };

    entity OrderItems : cuid {
        // key ID       : UUID;
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;
    };

    entity Suppliers : cuid, managed {
        // key ID         : UUID;
        Name       : String;
        Street     : type of materials.Products : Name; //Referenciado otra entidad
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phone      : String;
        Fax        : String;
        Product    : Association to many materials.Products
                         on Product.Supplier = $self;
    };

    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);
    };

    entity SalesData : managed {
        key ID            : UUID;
            DeliveryDate  : DateTime;
            Revenue       : Decimal(16, 2);
            Product       : Association to materials.Products;
            Currency      : Association to materials.Currencies;
            DeliveryMonth : Association to Months;
    }

    // Entidades de proyeccion o select de una entidad existente
    entity SelProducts  as select from materials.Products;

    entity SelProducts1 as
        select from materials.Products {
            Name,
            Price,
            Quantity
        };

    entity SelProducts2 as
        select from materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            Rating,
            Products.Name,
            sum(Price) as TotalPrice
        }
        group by
            Rating,
            Products.Name
        order by
            Rating desc;

    // TIPO ESTRUCTURADO REFERENCIADO

    entity Suppliers_01 {
        key ID      : UUID;
            Name    : String;
            Address : Address;
            Email   : String;
            Phone   : String;
            Fax     : String;
    };

};
