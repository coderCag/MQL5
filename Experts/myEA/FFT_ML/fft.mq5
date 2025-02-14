#include <Math\Alglib\fasttransforms.mqh>
#include <Expert\ExpertTrailing.mqh>




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
    ArrayResize(m_fft_out,m_size);
    
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
    m_open.Refresh();
    for(int i=0;i<m_size;i++)
    {
        m_fft_in[i]=m_close.GetData(i+m_start_index)-m_open.GetData(i+m_start_index);
    }


    return true;
}

