/*
Jenniffer Estrada
CSCI 6940: Networking Assignment - router.cc assignment
Spring 2016

This function computes forwarding of a packet in an IP router with three input parameters:
- An IP address (a 32 bit integer)
- A table with three integers per entry:
    1. an IP address
    2. a subnet mask
    3. the output line to be used
- The number of entries in the table

Returns the output line to be used vi given the input IP address

NOTE: Commented out a lot of debugging code and useful information used during development and testing
*/

using namespace std;

int route(int x, int routing_table[][3], int table_size){
//cout << endl;
int portnum=-1, ports[table_size];

//cout << "table size: " << table_size << endl;
//cout << endl;
//cout << "Port Ranges:" << endl;
int bottom[table_size],top[table_size];
    for (int i=0;i<table_size;i++){
            bottom[i] = (routing_table[i][0] & 0xFF);
            top[i] = (routing_table[i][0] & 0xFF) - (routing_table[i][1]);
            ports[i] = routing_table[i][2];
  //              cout << bottom[i] << ":" << top[i] << " ";
    //            cout << "Port: " <<  routing_table[i][2];
     //   cout << endl;
    }
//cout << endl;

    /*cout << "IP ADDRESS: " << ((x >> 24) & 0xFF) << '.'
                << ((x >> 16) & 0xFF) << '.'
                << ((x >> 8) & 0xFF) << '.'
                << (x & 0xFF) << endl;
*/
    int target = (x & 0xFF);
    //cout << target << endl;
    int k=0, possible[table_size];
    for (int i = 0; i < table_size; i++){
        if (target>=bottom[i] && target <= top[i]){
                    possible[k]=  ports[i];
                    if (k >0 && bottom[i] > bottom[i-1])
                        portnum = possible[k];
                        //cout << "correct port: "<< possible[k] << " from " <<bottom[i]  << " to "<< top[i] << endl;
                     else if (k >0 && bottom[i] < bottom[i-1])
                        portnum = possible[k-1];
                        //cout << "correct port: "<< possible[k-1] << " from " <<bottom[i-1]  << " to "<< top[i-1] << endl;
                    k++;
        }
    }

if (k==1){
        portnum = possible[0];
}
/*else{
        for (int i = 0; i<k; i++)
        {
            //if (top[i]> top[i-1])
                 //portnum = possible[i];
            //else if (target - bottom[i] >= target - bottom[i-1] && target - top[i] >= target - top[i-1] )
             //   portnum = possible[i-1];
            //cout << "MATCH "<<i+1 <<": " << possible[i] << " top: " << top[i] << " bottom: " << bottom[i]<< endl;
            //portnum = possible[i];
        }

}
*/


                /*
    for (int i=0;i<table_size;i++){
        for (int j=0;j<3;j++){


            if (j==0){
                cout << "IP ADDRESS: " << ((routing_table[i][j] >> 24) & 0xFF) << '.'
                << ((routing_table[i][j] >> 16) & 0xFF) << '.'
                << ((routing_table[i][j] >> 8) & 0xFF) << '.'
                << (routing_table[i][j] & 0xFF) << ' ';
            }

            else if (j == 1){
                cout << "subnet mask:" << 256 + routing_table[i][j] << " : " << routing_table[i][j] << " ";
            }
            else {
                cout << "Port: " <<  routing_table[i][j];

            }
        }
        cout << endl;
    }
    */
//cout << "portnum = "<<portnum <<endl;
return portnum;
}
