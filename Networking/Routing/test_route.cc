#include <iostream>
#include "estrada_router.cc"
using namespace std;

#define MAKE_DOTTED(A,B,C,D)  ((A<<24)|(B<<16)|(C<<8)|(D))

//int route(int x, int routing_table[][3], const int table_size);

int make_int_from_dotted (int inputA, int inputB, int inputC, int inputD)
{
return (inputA << 24 | inputB << 16 | inputC << 8 | inputD);
}

void print_dotted (int IP)
{
    cout << ((IP >> 24) & 0xFF) << '.'
	 << ((IP >> 16) & 0xFF) << '.'
	 << ((IP >> 8) & 0xFF) << '.'
	 << (IP & 0xFF) << ' ';
}

int main ()
{
    int routing_table[][3] = {
				MAKE_DOTTED(84,92,130,64),  MAKE_DOTTED(255,255,255,192),  3,
				MAKE_DOTTED(84,92,130,128), MAKE_DOTTED(255,255,255,192),  4,
				MAKE_DOTTED(84,92,130,0),   MAKE_DOTTED(255,255,255,0),    2,
				MAKE_DOTTED(84,92,130,176), MAKE_DOTTED(255,255,255,240),  1
			     };
    int x;
    const int table_size = sizeof(routing_table) / (3 * sizeof(int));

cout << endl;

    x = MAKE_DOTTED(84,92,130,5) ;

    //cout << "Inputs: ";
    //route(x, routing_table, table_size);
//    cout << endl;

    //cout << "Answers:"<<endl;
    print_dotted (x);
    cout<<"/2" <<endl;
    cout << "  will be routed on port " << route(x, routing_table, table_size)<< endl; // should be 2
cout<< endl;

    x = MAKE_DOTTED(84,92,130,69) ;
    print_dotted (x);
    cout<<"/3" <<endl;
    cout << "  will be routed on port " << route(x, routing_table, table_size)<< endl; // should be 3
cout<< endl;

    x = MAKE_DOTTED(84,92,130,133) ;
    print_dotted (x);
    cout<<"/4" <<endl;
    cout << "  will be routed on port " << route(x, routing_table, table_size)<< endl; // should be 4
cout<< endl;

    x = MAKE_DOTTED(84,92,130,181) ;
    print_dotted (x);
    cout<<"/1" <<endl;
    cout << "  will be routed on port " << route(x, routing_table, table_size)<< endl; // should be 1
cout<< endl;

    x = MAKE_DOTTED(84,92,130,197) ;
    print_dotted (x);
    cout<<"/2" <<endl;
    cout << "  will be routed on port " << route(x, routing_table, table_size)<< endl; // should be 2
    cout<< endl;

return 0;
}


