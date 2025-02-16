#include <Math/Alglib/fasttransforms.mqh>
#include <Expert/ExpertTrailing.mqh>

#define MAX_ARRAY_SIZE 25


class CExpertFFT
{
protected:
    CFastFourierTransform FFT;

public:
    CiClose  *m_close;
    CiOpen   *m_open;
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    ulong m_magic;
    bool m_start_index;
    int m_size;
    double m_fft_in[];
    double m_fft_out[];


public:
    CExpertFFT(void);
    ~CExpertFFT(void);

    void SetinputSize(int size) {m_size=size;}
    bool Init(string symbol,ENUM_TIMEFRAMES period,int start_index,ulong magic);
    bool DeInit();
    bool GetFFTinput();
    bool FFTprocess();
    

};
CExpertFFT::CExpertFFT(void)
{

}
CExpertFFT::~CExpertFFT(void)
{
    
}
bool CExpertFFT::Init(string symbol,ENUM_TIMEFRAMES period,int start_index,ulong magic)
{
    m_close=new CiClose();
    m_open=new CiOpen();
    m_symbol=symbol;
    m_period=period;
    m_magic=magic;
    m_start_index=start_index;
    if(ArrayResize(m_fft_in,m_size,MAX_ARRAY_SIZE)<0)
    {
        Print("Error resizing FFT output array");
        return false;   
    }
    if(ArrayResize(m_fft_out,2*m_size,MAX_ARRAY_SIZE)<0)
    {
        Print("Error resizing FFT input array");
        return false;
    }


    if(!m_close.Create(symbol,period))
    {
        Print("Error creating close buffer");
        return false;
    }

    if(!m_open.Create(symbol,period))
    {
        Print("Error creating open buffer");
        return false;
    }
    return true;
    
}
bool CExpertFFT::DeInit()
{
    delete m_close;
    delete m_open;
    return true;
}
bool CExpertFFT::GetFFTinput()
{
    m_close.Refresh();
    Print(m_close.Timeframe());
    m_open.Refresh();
    for(int i=0;i<m_size;i++)
    {
        m_fft_in[i]=m_close.GetData(i+m_start_index)-m_open.GetData(i+m_start_index);
    }
    return true;
}
bool CExpertFFT::FFTprocess()
{
    complex _f[];
    FFT.FFTR1D(m_fft_in,m_size,_f);
    for(int i=0;i<m_size;i++)
    {
        m_fft_out[2*i]=_f[i].real;
        m_fft_out[2*i+1]=_f[i].imag;
    }
    return true;
}
CExpertFFT FFT;
void OnInit()
{
    FFT.SetinputSize(6);
    FFT.Init(_Symbol,_Period,1,12345);
    


}
void OnTick()
{
    if(isNewBar())
    {
        if(FFT.GetFFTinput())
        {
            FFT.FFTprocess();
        }
        ArrayPrint(FFT.m_fft_in);
        ArrayPrint(FFT.m_fft_out);

    }



    
}
bool isNewBar()
{
    static long last_time = 0;
    long bartime = SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
    if(last_time == 0)
    {
        last_time = bartime;
        return false;

    }
    if(last_time != bartime)
    {
        last_time = bartime;
        return true;
    }

    return false;
}

