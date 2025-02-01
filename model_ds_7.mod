/*********************************************
 * OPL 22.1.1.0 Model
 * Author: Fouzan
 * Creation Date: Dec 3, 2023 at 11:21:22 AM
 *********************************************/
int n = ...; //Number of factory locations
int l = ...; //Number of suppliers
int t = ...; //Number of warehouse locations
int m = ...; //Number of markets or demand points

range Factories = 1..n;
range Suppliers = 1..l;
range Warehouses = 1..t;
range Markets = 1..m;

//Parameters
float Ki[Factories] = ...; //capacity of factory at site i
float Sh[Suppliers] = ...; //Supply capacity at supplier h
float We[Warehouses] = ...; //warehouse capacity at site e
float Dj[Markets] = ...; //Annual demand from customer j
float Fi[Factories] = ...; //Fixed cost of locating a plant at site i
float Fe[Warehouses] = ...; //Fixed cost of locating a warehouse at site e
float Chi[Suppliers][Factories] = ...; //Cost of shipping one unit from supply source h to factory i
float Cie[Factories][Warehouses] = ...; //Cost of shipping one unit from factory i to warehouse e
float Cej[Warehouses][Markets] = ...; //Cost of shipping one unit from warehouse e to customer j

//decision variables
dvar boolean Yi[Factories]; //1 if plant is located at site i, 0 otherwise
dvar boolean Ye[Warehouses]; //1 if warehouse is located at site e, 0 otherwise
dvar float+ Xhi[Suppliers][Factories]; //Quantity shipped from supplier h to factory i
dvar float+ Xie[Factories][Warehouses]; //Quantity transported from plant i to warehouse e
dvar float+ Xej[Warehouses][Markets]; //Quantity shipped from warehouse e to market j

//objective function
minimize
  sum(i in Factories) Fi[i] * Yi[i] +
  sum(e in Warehouses) Fe[e] * Ye[e] +
  sum(h in Suppliers, i in Factories) Chi[h][i] * Xhi[h][i] +
  sum(i in Factories, e in Warehouses) Cie[i][e] * Xie[i][e] +
  sum(e in Warehouses, j in Markets) Cej[e][j] * Xej[e][j];

//constraints
subject to {
  //Supply capacity constraint
  forall(h in Suppliers)
    sum(i in Factories) Xhi[h][i] <= Sh[h];

  //Factory production constraint
  forall(i in Factories)
    (sum(h in Suppliers) Xhi[h][i] - sum(e in Warehouses) Xie[i][e]) >= 0;

  //Factory capacity constraint
  forall(i in Factories, e in Warehouses)
    Xie[i][e] <= Ki[i] * Yi[i];

  //Warehouse throughput constraint
  forall(e in Warehouses)
    sum(i in Factories) Xie[i][e] - sum(j in Markets) Xej[e][j] >= 0;

  //Market demand constraint
  forall(j in Markets)
    sum(e in Warehouses) Xej[e][j] == Dj[j];
}