#include <iostream>
#include <string>
//#include <string.h>

using namespace std;

int main() {
string key = "estr";
string ptext = "welcometoencodingandencryption";

int plen = ptext.length(),klen = key.length();
int times = (plen / klen), k = 0;

while (key.length()< (klen*times)){ // make full key
    key.append(key);
}

for (int j = 0; j < ptext.length(); j++){
    k = (key[j] - 'a');
    if(ptext[j] + k >='a' && ptext[j] + k <='z'){
        cout  << char (ptext[j] + k); //
    }
    else {
        cout  << char (ptext[j] - 'z' + k -1 + 'a'); // wrap around
    }
}

return 0;
}
