symbols =['BTCUSDT','ETHUSDT','BNBUSDT','XRPUSDT', 
  'ADAUSDT','SOLUSDT','AVAXUSDT','LUNAUSDT','DOTUSDT',
  'DOGEUSTD','SHIBUSDT','MATUSDT','LTCUSDT','ATOMUSDT',
  'LINKUSDT','TRXUSDT','NEARUSDT','BCHUSDT','ALGOUSDT',
  'FTTUSDT','XLMUSDT','FTMUSDT','UNIUSDT','HBARUSDT',
  'MANAUSDT','ICPUSDT','ETCUSDT','AXSUSDT','SANUSDT',
  'EGLDUSDT','KLAYUSDT','VETUSDT','FILUSDT','THETUSDT',
  'XTZUSDT','XMRUSDT','GRTUSDT','HNTUSDT','EOSUSDT',
  'CAKEUSDT','GALAUSDT','FLOWUSDT','TFUELUSDT','AAVUSDT',
  'ONEUSDT','NEOUSDT','MKEUSDT','QNTUSDT','ENJUSDT',
  'XECUSDT']
import pandas as pd
posframe=pd.DataFrame(symbols)
posframe.columns = ['currency']
posframe['position'] = 0
posframe['quantity'] = 0
posframe.to_csv('positioncheck',index=False)

filename = 'binance_key'
def get_file_contents(filename):
    """ Given a filename,
        return the contents of that file
    """
    try:
        with open(filename, 'r') as f:
            # It's assumed our file contains a single line,
            # with our API key
            return f.read().strip()
    except FileNotFoundError:
        print("'%s' file not found" % filename)
binance_key = get_file_contents(filename)
#print("Our API key is: %s" % (binance_key))

filename = 'binance_secret'
def get_file_contents(filename):
    """ Given a filename,
        return the contents of that file
    """
    try:
        with open(filename, 'r') as f:
            # It's assumed our file contains a single line,
            # with our API key
            return f.read().strip()
    except FileNotFoundError:
        print("'%s' file not found" % filename)
binance_secret = get_file_contents(filename)
#print("Our API secret is: %s" % (binance_secret))

from binance import Client
import pandas as pd
client = Client(binance_key, binance_secret)
posframe = pd.read_csv('positioncheck')

def gethourlydata(symbol):
    frame = pd.DataFrame(client.get_historical_klines(symbol, 
                                                      '1h',
                                                      '75 hours ago UTC'))
    frame = frame[[0,4]]
    frame.columns = ['Time', 'Close']
    frame.Close = frame.Close.astype(float)
    frame.Time = pd.to_datetime(frame.Time, unit='ms')
    return frame 
temp = gethourlydata('BTCUSDT')

def applytechnicals(df):
    df['FastSMA'] = df.Close.rolling(5).mean()
    df['SlowSMA'] = df.Close.rolling(75).mean()
applytechnicals(temp)
def changepos(curr, order, buy=True):
    if buy:
        posframe.loc[posframe.Currency == curr, 'position'] = 1
        posframe.loc[posframe.Currency == curr, 'quantity'] = float(order['executedQty'])
