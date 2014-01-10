package org.blackbananacoin.twd2btc;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Random;

import org.junit.Test;

public class TwdJsonBuilderTest {

	@Test
	public void testBuildJson() {
		TwdJsonBuilder tb = new TwdJsonBuilder();
		String buildJson = tb.buildJson(30d, 100d);
		System.out.println(buildJson);
		TwdBit tbit = tb.toTwdBit(buildJson);
		// System.out.println("Double.compare="+Double.compare(tbit.getBtctwd(),3000d));
		assertEquals(Double.compare(tbit.getBtctwd(), 3000d), 0);

	}

	@Test
	public void testBuildJsonFromOld() {
		TwdJsonBuilder jb = new TwdJsonBuilder();
		String raw1 = "{\"usdtwd\":30.0,\"btcusd\":100.0,\"txfeetwd\":0.3,\"btctwd\":3000.0,\"time\":\"2014-01-10T14:35:47CST\",\"timems\":1389335747754,\"data24hr\":[3000]}";
		TwdBit tb1 = jb.toTwdBit(raw1);
		String tb2Str = jb.buildJsonFromOldTwdBit(tb1, 31.0d, 200.0d);
		System.out.println(tb2Str);
		TwdBit tb3 = jb.toTwdBit(tb2Str);
		assertEquals(Double.compare(tb3.getBtctwd(), 6200d), 0);
		List<Integer> list = tb3.getData24hr();
		assertEquals(list.size(), 2);
		assertEquals(list.get(0).intValue(), 3000);
		assertEquals(list.get(1).intValue(), 6200);
	}
	
	@Test
	public void testBuildJsonStat() {
		TwdJsonBuilder jb = new TwdJsonBuilder();
		String raw1 = "{\"usdtwd\":30.0,\"btcusd\":100.0,\"txfeetwd\":0.3,\"btctwd\":3000.0,\"time\":\"2014-01-10T14:35:47CST\",\"timems\":1389335747754,\"data24hr\":[3000]}";
		TwdBit tb1 = jb.toTwdBit(raw1);
		Random ran = new Random();
		for (int i = 0; i < 200; i++) {
			String tb2Str = jb.buildJsonFromOldTwdBit(tb1, 31.0d, 200.0d+ran.nextInt(100));
			//System.out.println(tb2Str);
			tb1 = jb.toTwdBit(tb2Str);
		}
		
		System.out.println(jb.toJson(tb1));
		List<Integer> list = tb1.getData24hr();
		assertEquals(144, list.size());
	}

}
