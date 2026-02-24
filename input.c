int a=5, b=10, c, d=10;
int i=0, j=0, p=5, q=5;
int arr1[15];
int arr2[10][10];
int arr3[1][2][3][4];
int m[4][4], n[5];
float x;
double y;
char ch;

c = a + b * 2;
x = 3;
y = 4;
ch = 1;

if (c > 10) {
    x = x + 1;
} else {
    x = x - 1;
}

while (a < b) {
    a = a + 1;
    b = b - 1;
}

for(i=0, j=0; i<p&&j<q; i++, j++) {
    c = c + i;
}

do {
    a = a + 1;
    b = b - 1;
} while (a < b);

switch (c) {
    case 1:
        c = c + 1;
        break;
    case 2:
        c = c - 1;
        break;
    default:
        c = 0;
}
