#include <fstream>
#include <string.h>
#include <iomanip>

using namespace std;

int main(){
const int NLETTERS = 26;
int key;
char ctext[] = "EVIRE";
char ptext[strlen(ctext)];

ofstream fin;
fin.open("ptext.txt");

fin << "Cipher Text: " << ctext << "\n\n";

for (int j = 1; j < 26; j++){
    key = j % NLETTERS;
    fin << setw(2) << key << " : ";
    for (int i=0;i<strlen(ctext);i++){
        if(ctext[i]+ key >='A' && ctext[i]+ key <='Z') // use only capital letters
            {
            fin  << char (ctext[i] + key); //
            }
        else {
            fin  << char (ctext[i] - 'Z' + key -1 + 'A');} // wrap around
    }
    fin << "\n";
    }
return 0;
}
