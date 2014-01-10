package org.blackbananacoin.twd2btc;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class TwdJsonBuilder {

	private Gson gson = new GsonBuilder().setDateFormat(
			"yyyy-MM-dd'T'HH:mm:ssz").create();

	/**
	 * @param usdtwd
	 * @param btcusd
	 * @return
	 */
	public String buildJson(double usdtwd, double btcusd) {
		TwdBit twdBit = new TwdBit(usdtwd, btcusd);
		return gson.toJson(twdBit);
	}

	public String buildJsonFromOldTwdBit(TwdBit tb, double usdtwd, double btcusd) {
		tb.update(usdtwd, btcusd);
		return gson.toJson(tb);
	}

	public TwdBit toTwdBit(String json) {
		return gson.fromJson(json, TwdBit.class);
	}
	
	public String toJson(TwdBit tb) {
		return gson.toJson(tb);
	}
	
	

}
