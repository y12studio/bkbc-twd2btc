package org.blackbananacoin.twd2btc;

import static org.junit.Assert.*;

import org.junit.Test;

public class TwdJsonBuilderTest {

	@Test
	public void testBuildJson() {
		TwdJsonBuilder tb = new TwdJsonBuilder();
		String buildJson = tb.buildJson(30d,100d);
		System.out.println(buildJson);
		TwdBit tbit = tb.parse(buildJson);
		//System.out.println("Double.compare="+Double.compare(tbit.getBtctwd(),3000d));
		assertEquals(Double.compare(tbit.getBtctwd(),3000d),0);
		
	}

}
