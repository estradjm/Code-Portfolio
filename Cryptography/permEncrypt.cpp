#include <iostream>
#include <sstream>
#include <bitset>

using namespace std;

int main(){

const int perm[] = {3, 1, 5, 6, 2, 8, 7, 4}; // permuation box
int banner = 25; // last two digits of banner ID = 25
string String = static_cast<ostringstream*>( &(ostringstream() << banner) )->str(); // this got ugly fast...
string binaryStr; // nibble sized binary string
string a,b, c;
int k = 0;

// create binary string to permute
for (int i = 0; i < String.length(); ++i){
    bitset<4> b(String.c_str()[i]);
    binaryStr= b.to_string();
    for(int j = 0; j < binaryStr.length(); j++){
        a[k] = binaryStr[j];
        k++;
    }
  }

// Encrypt binary string using permutation box
for (int l = 0; l < k; l++){
    //b[perm[l]] = a[l];
   cout << a[perm[l]-1]<< " "<< perm[l] << " " << l << endl;

}

return 0;
}
