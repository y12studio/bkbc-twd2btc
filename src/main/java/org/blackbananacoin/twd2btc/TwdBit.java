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
import java.util.List;

import org.apache.commons.math3.stat.StatUtils;

import com.google.api.client.util.Lists;
import com.google.common.primitives.Doubles;

public class TwdBit {

	private static final int MAX_LEN = 24*6;
	
	private double usdtwd = 1.0d;
	private double btcusd = 1.0d;
	private double txfeetwd = 1.0d;
	private double btctwd = 1.0d;

	private Date time;
	private long timems;
	
	private List<Integer> data24hr = Lists.newArrayList();

	private double mean24hr;

	private double max24hr;

	private double min24hr;

	private double std24hr;

	private double median24hr;

	public TwdBit(double usdtwd, double btcusd) {
		update(usdtwd,btcusd);
	}
	
	public void appendNewData(){
		int r = ((Double) btctwd).intValue();
		data24hr.add(r);
		if(data24hr.size()>MAX_LEN){
			data24hr.remove(0);
		}
		processStat();
	}

	public void update(double usdtwd, double btcusd) {
		this.setUsdtwd(usdtwd);
		this.setBtcusd(btcusd);
		time = new Date();
		timems = this.time.getTime();
		// min tx fee 0.0001 (BTC)
		setBtctwd(getBtcusd() * getUsdtwd());
		setTxfeetwd(getBtctwd() * 0.0001d);
		appendNewData();
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

	public List<Integer> getData24hr() {
		return data24hr;
	}

	public void setData24hr(List<Integer> data24hr) {
		this.data24hr = data24hr;
	}
	
	public void processStat(){
		double[] values = Doubles.toArray(data24hr);
		setMean24hr(StatUtils.mean(values));
		setMax24hr(StatUtils.max(values));
		setMin24hr(StatUtils.min(values));
		setStd24hr(Math.sqrt(StatUtils.variance(values)));
		setMedian24hr(StatUtils.percentile(values, 50));
	}

	public double getMean24hr() {
		return mean24hr;
	}

	public void setMean24hr(double mean24hr) {
		this.mean24hr = mean24hr;
	}

	public double getMax24hr() {
		return max24hr;
	}

	public void setMax24hr(double max24hr) {
		this.max24hr = max24hr;
	}

	public double getMin24hr() {
		return min24hr;
	}

	public void setMin24hr(double min24hr) {
		this.min24hr = min24hr;
	}

	public double getStd24hr() {
		return std24hr;
	}

	public void setStd24hr(double std24hr) {
		this.std24hr = std24hr;
	}

	public double getMedian24hr() {
		return median24hr;
	}

	public void setMedian24hr(double median24hr) {
		this.median24hr = median24hr;
	}

}
