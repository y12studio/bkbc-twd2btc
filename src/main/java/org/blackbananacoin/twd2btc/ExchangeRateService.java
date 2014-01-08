package org.blackbananacoin.twd2btc;

import org.blackbananacoin.twd2btc.ExtRateGenServiceImpl.MyCallback;

public interface ExchangeRateService {

	void startRequest(MyCallback mcb) throws Exception;

}
