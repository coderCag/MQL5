#include <Expert/ExpertTrailing.mqh>
#include <Math/Alglib/fasttransforms.mqh>



#define EPICYCLES 5
class CTrailingFFT:public CExpertTrailing
{
protected:
    CFastFourierTransform   FFT;
    double  m_step;
    int     m_index;
public:
    virtual bool    ValidationSettings(void);
    virtual bool    InitIndicators(CIndicators *indicators);
    virtual bool    CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp);
    virtual bool    CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp);
                    CTrailingFFT(void);
                    ~CTrailingFFT(void);
    void            Step(double step){m_step=step;}
    void            Index(int index){m_index=index;}
protected:
    double  ProcessFT(int index);

};
CTrailingFFT::CTrailingFFT(void)
{
    m_used_series = USE_SERIES_TIME+USE_SERIES_SPREAD+USE_SERIES_OPEN+USE_SERIES_HIGH+USE_SERIES_LOW+USE_SERIES_CLOSE;
}
CTrailingFFT::~CTrailingFFT(void)
{
    
}
bool CTrailingFFT::ValidationSettings(void)
{
    if(!CExpertTrailing::ValidationSettings())
    {
        return false;
    }
    if(m_index<=0 || m_index>=EPICYCLES)
    {
        printf(__FUNCTION__+": index must be greater than 0 and less than EPICYCLES\n");
        return false;
    }
    return true;
}
bool CTrailingFFT::InitIndicators(CIndicators *indicators)
{
    if(indicators == NULL)
    {
        return false;
    }
    if(!CExpertTrailing::InitIndicators(indicators))
    {
        return false;
    }
    return true;
}
bool CTrailingFFT::CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp)
{
    if(position == NULL)
    {
        return false;
    }
    m_high->Refresh(-1);
}