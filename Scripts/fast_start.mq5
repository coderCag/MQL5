
int iMA_handle; 
long id;
void OnStart()
{
    iMA_handle=iMA("EURUSD",PERIOD_H1,10,0,MODE_SMA,PRICE_CLOSE);
    id =  AccountInfoInteger(ACCOUNT_LOGIN);
    printf("%d",id);

}
