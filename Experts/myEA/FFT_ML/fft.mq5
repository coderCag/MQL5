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
    bool m_every_tick;
    int m_size;


public:
    CExpertFFT(void);
    ~CExpertFFT(void);

    void SetinputSize(int size) {m_size=size;}
    bool Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,ulong magic);
    bool DeInit();
    bool GetFFTinput(CDoubleBuffer *in,int size);
    bool FFTprocess(CDoubleBuffer *out,int size);
    

};
CExpertFFT::CExpertFFT(void)
{

}
CExpertFFT::~CExpertFFT(void)
{
    
}
bool CExpertFFT::Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,ulong magic)
{
    m_close=new CiClose();
    m_open=new CiOpen();
    m_symbol=symbol;
    m_period=period;
    m_magic=magic;
    m_every_tick=every_tick;
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
bool CExpertFFT::GetFFTinput(CDoubleBuffer *in,int size)
{
    m_close.Refresh();
    m_open.Refresh();
}

