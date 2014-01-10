/*
 * Copyright 2013 Y12STUDIO
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.blackbananacoin.twd2btc;

import java.util.Date;

public class TwdBit {

	private double usdtwd = 1.0d;
	private double btcusd = 1.0d;
	private double txfeetwd = 1.0d;
	private double btctwd = 1.0d;

	private Date time;
	private long timems;

	public TwdBit(double usdtwd, double btcusd) {
		this.setUsdtwd(usdtwd);
		this.setBtcusd(btcusd);
		update();
	}

	public void update() {
		time = new Date();
		timems = this.time.getTime();
		// min tx fee 0.0001 (BTC)
		setBtctwd(getBtcusd() * getUsdtwd());
		setTxfeetwd(getBtctwd() * 0.0001d);
	}

	public double getUsdtwd() {
		return usdtwd;
	}

	public void setUsdtwd(double usdtwd) {
		this.usdtwd = usdtwd;
	}

	public double getBtcusd() {
		return btcusd;
	}

	public void setBtcusd(double btcusd) {
		this.btcusd = btcusd;
	}

	public double getTxfeetwd() {
		return txfeetwd;
	}

	public void setTxfeetwd(double txfeetwd) {
		this.txfeetwd = txfeetwd;
	}

	public double getBtctwd() {
		return btctwd;
	}

	public void setBtctwd(double btctwd) {
		this.btctwd = btctwd;
	}

}
