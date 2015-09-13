#include<iostream>
using namespace std;
class round_robin
{
    public:
        int a[10],i,quantum;
        string  b[10];
        int k,count;
        round_robin()
        {
            i=-1;
            k=-1;
        }
        void accept_quantum()
        {
            cout<<"Enter the quantum";
            cin>>quantum;
        }
        void insert()
        {   i++;
            cout<<"Enter process name and time";
            cin>>b[i]>>a[i];

        }
        void display()
        {
            for(int j=0;j<=i;j++)
            {
                if(a[j]==-1)
                {
                    j++;

                }
                else
                {
                    if(a[j]<=quantum)
                    {
                        cout<<b[j]<<"  ";
                        a[j]=-1;j++;
                    }
                    else
                    {
                        a[j]=a[j]-quantum;
                        cout<<b[j]<<" ";j++;

                    }
               }

                count=-1;
                for(k=0;k<=i;k++)
                {
                    if(a[k]==-1)
                    count++;
                }
                if(count==i)
                    break;
                else
                    {

                        if(j>i)
                        j=0;

                    }

            }
        }

};




int main()
{
    round_robin r;
    int d;

    r.accept_quantum();
    char  ch;
    do
    {


                cout<<"MENU\n\n1.INSERT\n2.DISPLAY\n";
                cout<<"Enter your choice";
                cin>>ch;
                switch(ch)
                {
                    case '1':r.insert();
                            break;
                    case '2':r.display();
                            break;

                }
            cout<<"do you want to continue(y/n)";
            cin>>ch;
            if(ch=='y'||ch=='Y')
            d=1;
            else
            d=0;

    }while(d);
    return 0;
}
