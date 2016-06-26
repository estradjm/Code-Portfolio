#include <iostream>
#include <fstream>
#include <map>

using namespace std;

int main()
{
const int NLETTERS = 26;
string str = "acewtqcgtcxwtlfxzoxlcxwvuhgftxfsutrwoxvcolgjfbutrovcltfxzcywceecxg";
map<char,int> letters;
int cnt=0;

ofstream fin;
fin.open("frequencyTable.txt");

fin << "Letter Frequency Table: \n\n" << endl;
fin << "Letter \t Frequency" << endl;

for (int i = 'a'; i < NLETTERS+ 'a'; i++){
    for(int j = 0; j<str.length(); j++ ){
      if(str[j] == i){
        cnt+=1;
        letters[i]=cnt;
        }
    }
  fin << char (i) << "\t " << letters[i] << endl;
  cnt = 0;
}

return 0;
}
