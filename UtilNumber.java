/*******************************************************************************
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *******************************************************************************/

package org.ofbiz.base.util;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Locale;

import com.ibm.icu.text.RuleBasedNumberFormat;

public class UtilNumber {

    public static String module = UtilNumber.class.getName();

    // properties file name for arithmetic configuration
    private static final String arithmeticPropertiesFile = "arithmetic.properties";

    // default scale and rounding mode for BigDecimals
    private static final int DEFAULT_BD_SCALE = 2;
    private static final int DEFAULT_BD_ROUNDING_MODE = BigDecimal.ROUND_HALF_UP;

    /**
     * Method to get BigDecimal scale factor from a property
     * @param   file     - Name of the property file
     * @param   property - Name of the config property from arithmeticPropertiesFile (e.g., "invoice.decimals")
     * @return  int - Scale factor to pass to BigDecimal's methods. Defaults to DEFAULT_BD_SCALE (2)
     */
    public static int getBigDecimalScale(String file, String property) {
        if (UtilValidate.isEmpty(file)) return DEFAULT_BD_SCALE;
        if (UtilValidate.isEmpty(property)) return DEFAULT_BD_SCALE;

        int scale = -1;
        String value = UtilProperties.getPropertyValue(file, property);
        if (value != null) {
            try {
                scale = Integer.parseInt(value);
            } catch (NumberFormatException e) {
            }
        }
        if (scale == -1) {
            Debug.logWarning("Could not set decimal precision from " + property + "=" + value + ". Using default scale of " + DEFAULT_BD_SCALE + ".", module);
            scale = DEFAULT_BD_SCALE;
        }
        return scale;
    }

    /**
     * As above, but use the default properties file
     */
    public static int getBigDecimalScale(String property) {
        return getBigDecimalScale(arithmeticPropertiesFile, property);
    }

    /**
     * Method to get BigDecimal rounding mode from a property
     * @param   file     - Name of the property file
     * @param   property - Name of the config property from arithmeticPropertiesFile (e.g., "invoice.rounding")
     * @return  int - Rounding mode to pass to BigDecimal's methods. Defaults to DEFAULT_BD_ROUNDING_MODE (BigDecimal.ROUND_HALF_UP)
     */
    public static int getBigDecimalRoundingMode(String file, String property) {
        if (UtilValidate.isEmpty(file)) return DEFAULT_BD_SCALE;
        if (UtilValidate.isEmpty(property)) return DEFAULT_BD_ROUNDING_MODE;

        String value = UtilProperties.getPropertyValue(file, property);
        int mode = roundingModeFromString(value);
        if (mode == -1) {
            Debug.logWarning("Could not set decimal rounding mode from " + property + "=" + value + ". Using default mode of " + DEFAULT_BD_SCALE + ".", module);
            return DEFAULT_BD_ROUNDING_MODE;
        }
        return mode;
    }

    /**
     * As above, but use the default properties file
     */
    public static int getBigDecimalRoundingMode(String property) {
        return getBigDecimalRoundingMode(arithmeticPropertiesFile, property);
    }

    /**
     * Method to get the BigDecimal rounding mode int value from a string name.
     * @param   value - The name of the mode (e.g., "ROUND_HALF_UP")
     * @return  int - The int value of the mode (e.g, BigDecimal.ROUND_HALF_UP) or -1 if the input was bad.
     */
    public static int roundingModeFromString(String value) {
        if (value == null) return -1;
        value = value.trim();
        if ("ROUND_HALF_UP".equals(value)) return BigDecimal.ROUND_HALF_UP;
        else if ("ROUND_HALF_DOWN".equals(value)) return BigDecimal.ROUND_HALF_DOWN;
        else if ("ROUND_HALF_EVEN".equals(value)) return BigDecimal.ROUND_HALF_EVEN;
        else if ("ROUND_UP".equals(value)) return BigDecimal.ROUND_UP;
        else if ("ROUND_DOWN".equals(value)) return BigDecimal.ROUND_DOWN;
        else if ("ROUND_CEILING".equals(value)) return BigDecimal.ROUND_CEILING;
        else if ("ROUND_FLOOR".equals(value)) return BigDecimal.ROUND_FLOOR;
        else if ("ROUND_UNNECCESSARY".equals(value)) return BigDecimal.ROUND_UNNECESSARY;
        return -1;
    }

    // ICU4J rule sets for the en_US locale. To add more rules, expand this string.
    // For reference, see the RbnfSampleRuleSets.java file distributed with ICU4J
    public static final String ruleSet_en_US =
        /*
         * These rules format a number in one of the two styles often used
         * on checks.  %dollars-and-hundredths formats cents as hundredths of
         * a dollar (23.40 comes out as "twenty-three and 40/100 dollars").
         * %dollars-and-cents formats in dollars and cents (23.40 comes out as
         * "twenty-three dollars and forty cents")
         */
        "%dollars-and-cents:\n"
        + "    x.0: << [and >%%cents>];\n"
        + "    0.x: >%%cents>;\n"
        + "    0: zero dollars; one dollar; =%%main= dollars;\n"
        + "%%main:\n"
        + "    zero; one; two; three; four; five; six; seven; eight; nine;\n"
        + "    ten; eleven; twelve; thirteen; fourteen; fifteen; sixteen;\n"
        + "        seventeen; eighteen; nineteen;\n"
        + "    20: twenty[->>];\n"
        + "    30: thirty[->>];\n"
        + "    40: forty[->>];\n"
        + "    50: fifty[->>];\n"
        + "    60: sixty[->>];\n"
        + "    70: seventy[->>];\n"
        + "    80: eighty[->>];\n"
        + "    90: ninety[->>];\n"
        + "    100: << hundred[ >>];\n"
        + "    1000: << thousand[ >>];\n"
        + "    1,000,000: << million[ >>];\n"
        + "    1,000,000,000: << billion[ >>];\n"
        + "    1,000,000,000,000: << trillion[ >>];\n"
        + "    1,000,000,000,000,000: =#,##0=;\n"
        + "%%cents:\n"
        + "    100: <%%main< cent[s];\n"
        + "%dollars-and-hundredths:\n"
        + "    x.0: <%%main< and >%%hundredths>/100;\n" // this used to end in 'dollars' but that should be added later
        + "%%hundredths:\n"
        + "    100: <00<;\n";
    

    /**
     * Spellout rules for Spanish.  The Spanish rules are quite similar to
     * the English rules, but there are some important differences:
     * First, we have to provide separate rules for most of the twenties
     * because the ones digit frequently picks up an accent mark that it
     * doesn't have when standing alone.  Second, each multiple of 100 has
     * to be specified separately because the multiplier on 100 very often
     * changes form in the contraction: 500 is "quinientos," not
     * "cincocientos."  In addition, the word for 100 is "cien" when
     * standing alone, but changes to "ciento" when followed by more digits.
     * There also some other differences.
     */
    public static final String spanish =
        // negative-number and fraction rules
        "-x: menos >>;\n"
        + "x.x: << punto >>;\n"
        // words for values from 0 to 19
        + "cero; uno; dos; tres; cuatro; cinco; seis; siete; ocho; nueve;\n"
        + "diez; once; doce; trece; catorce; quince; diecis\u00e9is;\n"
        + "    diecisiete; dieciocho; diecinueve;\n"
        // words for values from 20 to 29 (necessary because the ones digit
        // often picks up an accent mark it doesn't have when standing alone)
        + "veinte; veintiuno; veintid\u00f3s; veintitr\u00e9s; veinticuatro;\n"
        + "    veinticinco; veintis\u00e9is; veintisiete; veintiocho;\n"
        + "    veintinueve;\n"
        // words for multiples of 10 (notice that the tens digit is separated
        // from the ones digit by the word "y".)
        + "30: treinta[ y >>];\n"
        + "40: cuarenta[ y >>];\n"
        + "50: cincuenta[ y >>];\n"
        + "60: sesenta[ y >>];\n"
        + "70: setenta[ y >>];\n"
        + "80: ochenta[ y >>];\n"
        + "90: noventa[ y >>];\n"
        // 100 by itself is "cien," but 100 followed by something is "cineto"
        + "100: cien;\n"
        + "101: ciento >>;\n"
        // words for multiples of 100 (must be stated because they're
        // rarely simple concatenations)
        + "200: doscientos[ >>];\n"
        + "300: trescientos[ >>];\n"
        + "400: cuatrocientos[ >>];\n"
        + "500: quinientos[ >>];\n"
        + "600: seiscientos[ >>];\n"
        + "700: setecientos[ >>];\n"
        + "800: ochocientos[ >>];\n"
        + "900: novecientos[ >>];\n"
        // for 1,000, the multiplier on "mil" is omitted: 2,000 is "dos mil,"
        // but 1,000 is just "mil."
        + "1000: mil[ >>];\n"
        + "2000: << mil[ >>];\n"
        // 1,000,000 is "un millon," not "uno millon"
        + "1,000,000: un mill\u00f3n[ >>];\n"
        + "2,000,000: << mill\u00f3n[ >>];\n"
        // overflow rule
        + "1,000,000,000: =#,##0= (incomplete data);";
    // The Spanish rules are incomplete.  I'm missing information on negative
    // numbers and numbers with fractional parts.  I also don't have
    // information on numbers higher than the millions
    
    
    // ICU4J rule sets for the th_TH locale. To add more rules, expand this string.
    // For reference, see the RbnfSampleRuleSets.java file distributed with ICU4J
    public static final String ruleSet_th_TH =
        /*
         * These rules format a number in one of the two styles often used
         * on checks.  %bahts-and-hundredths formats stangs as hundredths of
         * a baht (23.40 comes out as "twenty-three and 40/100 bahts").
         * %bahts-and-stangs formats in bahts and stangs (23.40 comes out as
         * "twenty-three bahts and forty stangs")
         */
        "%bahts-and-stangs:\n"
        + "    x.0: << [and >%%stangs>];\n"
        + "    0.x: >%%stangs>;\n"
        + "    0: zero bahts; one baht; =%%main= bahts;\n"
        + "%%main:\n"
        + "    zero; one; two; three; four; five; six; seven; eight; nine;\n"
        + "    ten; eleven; twelve; thirteen; fourteen; fifteen; sixteen;\n"
        + "        seventeen; eighteen; nineteen;\n"
        + "    20: twenty[->>];\n"
        + "    30: thirty[->>];\n"
        + "    40: forty[->>];\n"
        + "    50: fifty[->>];\n"
        + "    60: sixty[->>];\n"
        + "    70: seventy[->>];\n"
        + "    80: eighty[->>];\n"
        + "    90: ninety[->>];\n"
        + "    100: << hundred[ >>];\n"
        + "    1000: << thousand[ >>];\n"
        + "    1,000,000: << million[ >>];\n"
        + "    1,000,000,000: << billion[ >>];\n"
        + "    1,000,000,000,000: << trillion[ >>];\n"
        + "    1,000,000,000,000,000: =#,##0=;\n"
        + "%%stangs:\n"
        + "    100: <%%main< stang[s];\n"
        + "%bahts-and-hundredths:\n"
        + "    x.0: <%%main< and >%%hundredths>/100;\n" // this used to end in 'bahts' but that should be added later
        + "%%hundredths:\n"
        + "    100: <00<;\n";

    // hash map to store ICU4J rule sets keyed to Locale
    public static HashMap<Locale, String> rbnfRuleSets;
    static {
        rbnfRuleSets = new HashMap<Locale, String>();
        rbnfRuleSets.put(Locale.US, ruleSet_en_US);
        rbnfRuleSets.put(new Locale("th"), ruleSet_th_TH);
        rbnfRuleSets.put(new Locale("es"), spanish);
    }

    /**
     * Method to format an amount using a custom rule set.
     * Current rule sets available:
     *
     * en_US
     * %dollars-and-cents - 1,225.25 becomes "one thousand two hundred twenty five dollars and twenty five cents" (useful for checks)
     * %dollars-and-hundreths - 1,225.25 becomes "one thousand two hundred twenty five and 25/00" (alternate for checks)
     *
     * @param   amount - the amount to format
     * @param   rule - the name of the rule set to use (e.g., %dollars-and-hundredths)
     * @param   locale - the Locale
     * @return  formatted string or an empty string if there was an error
     */
    public static String formatRuleBasedAmount(double amount, String rule, Locale locale) {
        String ruleSet = rbnfRuleSets.get(locale);
        if (ruleSet == null) {
        	Debug.logInfo("--------CODIGOLINUX------- " + locale.toString(), module);
            Debug.logWarning("Cannot format rule based amount for locale " + locale.toString() + " because rule set for that locale does not exist", module);
            //return "";
            
            ruleSet =
            		"%dollars-and-cents:\n"
            		        + "    x.0: << [y >%%cents>];\n"
            		        + "    0.x: >%%cents>;\n"
            		        + "    0: zero dollars; one dollar; =%%main= dollars;\n"
            		        + "%%main:\n"
            		        // words for values from 0 to 19
            		        + "    cero; uno; dos; tres; cuatro; cinco; seis; siete; ocho; nueve;\n"
            		        + "    diez; once; doce; trece; catorce; quince; diecis\u00e9is;\n"
            		        + "    diecisiete; dieciocho; diecinueve;\n"
            		        // words for values from 20 to 29 (necessary because the ones digit
            		        // often picks up an accent mark it doesn't have when standing alone)
            		        + "    veinte; veintiuno; veintid\u00f3s; veintitr\u00e9s; veinticuatro;\n"
            		        + "    veinticinco; veintis\u00e9is; veintisiete; veintiocho;\n"
            		        + "    veintinueve;\n"
            		        // words for multiples of 10 (notice that the tens digit is separated
            		        // from the ones digit by the word "y".)
            		        + "    30: treinta[ y >>];\n"
            		        + "    40: cuarenta[ y >>];\n"
            		        + "    50: cincuenta[ y >>];\n"
            		        + "    60: sesenta[ y >>];\n"
            		        + "    70: setenta[ y >>];\n"
            		        + "    80: ochenta[ y >>];\n"
            		        + "    90: noventa[ y >>];\n"
            		        // 100 by itself is "cien," but 100 followed by something is "cineto"
            		        + "    100: cien;\n"
            		        + "    101: ciento >>;\n"
            		        // words for multiples of 100 (must be stated because they're
            		        // rarely simple concatenations)
            		        + "    200: doscientos[ >>];\n"
            		        + "    300: trescientos[ >>];\n"
            		        + "    400: cuatrocientos[ >>];\n"
            		        + "    500: quinientos[ >>];\n"
            		        + "    600: seiscientos[ >>];\n"
            		        + "    700: setecientos[ >>];\n"
            		        + "    800: ochocientos[ >>];\n"
            		        + "    900: novecientos[ >>];\n"
            		        // for 1,000, the multiplier on "mil" is omitted: 2,000 is "dos mil,"
            		        // but 1,000 is just "mil."
            		        + "    1000: mil[ >>];\n"
            		        + "    2000: << mil[ >>];\n"
            		        // 1,000,000 is "un millon," not "uno millon"
            		        + "    1,000,000: un mill\u00f3n[ >>];\n"
            		        + "    2,000,000: << mill\u00f3n[ >>];\n"
            		        // overflow rule
            		        + "    1,000,000,000: =#,##0= (incomplete data);"
            		        + "%%cents:\n"
            		        + "    100: <%%main< cent[s];\n"  
            		        + "%dollars-and-hundredths:\n"
            		        + "    x.0: <%%main< y >%%hundredths>/100;\n" // this used to end in 'dollars' but that should be added later
            		        + "%guaranies:\n"
            		        + "    x.0: <%%main< guaranies>>;\n" // this used to end in 'dollars' but that should be added later
            		        + "%%hundredths:\n"
            		        + "    100: <00<;\n";
            
        }
        RuleBasedNumberFormat formatter = new RuleBasedNumberFormat(ruleSet, locale);
        String result = "";
        try {
            result = formatter.format(amount, rule);
        } catch (Exception e) {
            Debug.logError(e, "Failed to format amount " + amount + " using rule " + rule, module);
        }
        return result;
    }

    /**
     * Method to turn a number such as "0.9853" into a nicely formatted percent, "98.53%".
     *
     * @param number    The number object to format
     * @param scale     How many places after the decimal to include
     * @param roundingMode  The BigDecimal rounding mode to apply
     * @return          The formatted string or "" if there were errors.
     */
    public static String toPercentString(Number number, int scale, int roundingMode) {
        // convert to BigDecimal
        if (!(number instanceof BigDecimal)) {
            number = new BigDecimal(number.doubleValue());
        }

        // cast it so we can use BigDecimal methods
        BigDecimal bd = (BigDecimal) number;

        // multiply by 100 and set the scale
        bd = bd.multiply(new BigDecimal(100.0)).setScale(scale, roundingMode);

        return (bd.toString() + "%");
    }

    /**
     * A null-aware method for adding BigDecimal, but only for the right operand.
     *
     * @param left      The number to add to
     * @param right     The number being added; if null, then nothing will be added
     * @return          The result of the addition, or left if right is null.
     */
    public static BigDecimal safeAdd(BigDecimal left, BigDecimal right) {
        return right != null ? left.add(right) : left;
    }
}
