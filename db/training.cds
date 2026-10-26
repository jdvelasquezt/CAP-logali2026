namespace training;

using {
    cuid, // UUID
   managed //" Managed para campos de auditoria"
} from '@sap/cds/common'; 


// define type Name : String(20); Tipo definido
// Tipo matriz
// define type EmailAddresses_01 : array of {
//     Kind  : String;
//     Email : String;
// };

// define type EmailAddresses_02 {
//     Kind  : String;
//     Email : String;
// };

// entity Emails {
//     // 1ra declaración
//     Email_01 : EmailAddresses_01;
//     // segunda declaracion
//     Email_02 : many EmailAddresses_02;
//     // terecera declaracion
//     Email_03 : many {
//         Kind  : String;
//         Email : String;
//     }
// };
// END TIPO MATRIZ

// TIPO ESTRUCTURADO EN LINEA

// entity Suppliers_02 {
//     key ID      : UUID;
//         Name    : String;
//         Address : {
//             City       : String;
//             State      : String(2);
//             PostalCode : String(5);
//             Country    : String(3);
//         };
//         Email   : String;
//         Phone   : String;
//         Fax     : String;
// };
// END TIPO ESTRUCTURADO

// Entidad con parametros solo soportado por BD HANA no SQLITE
// entity ParamProducts(pName: String)     as
//     select
//         Name,
//         Price,
//         Quantity
//     from Products
//     where
//         Name = :pName;

// entity ProjParamProducts(pName: String) as projection on Products
//                                            where
//                                                Name = :pName;

// TO MANY 

entity Course : cuid {
    Student : Association to many StudentCourse
    on Student.Course = $self;
}

entity Student : cuid {
    Course : Association to many StudentCourse 
    on Course.Student = $self;
}

entity StudentCourse : cuid {
    Student : Association to Student;
    Course : Association to Course
}