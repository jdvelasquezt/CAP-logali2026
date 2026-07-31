using { cap_logali as CAP } from '../db/schema';

service CustomerService {

    entity CustomerSrv as projection on CAP.Customer;

}