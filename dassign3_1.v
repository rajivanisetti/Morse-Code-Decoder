/// EEM16 - Logic Design
// Design Assignment #3.1
// dassign3_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************

// 3.1a) Rectified linear unit
// out = max(0, in/4)
// 16 bit signed input
// 8 bit unsigned output
module relu(in, out);
    input [15:0] in;
    output [7:0] out;
  
  assign out = in[15] ? 8'b0 : in >> 2;

    
endmodule

// 3.1b) Pipelined 5 input ripple-carry adder
// 16 bit signed inputs
// 1 bit input: valid (when the other inputs are useful numbers)
// 16 bit signed output (truncated)
// 1 bit output: ready (when the output is the sum of valid inputs)
module piped_adder(clk, a, b, c, d, e, valid, sum, ready);
    input clk, valid;
    input [15:0] a, b, c, d, e;
    output [15:0] sum;
    output ready;
  
  
  wire valid1, valid2, valid3, valid4, valid5;
  wire [6:0] sumOne, sumOneA, sumTwo, sumTwoA, sumThree, sumThreeA, sumFour, sumFourA, sumFive, sumFiveA, sumSix, sumSixA, sumSeven, sumSevenA, sumEight, sumEightA;
  
  wire [3:0] sum30, sum30A, sum30B,sum30C, sum30D, sum74, sum74A, sum74B, sum74C, sum118, sum118A, sum118B, sum1512, sum1512A, sumFrom1A, sumFrom2, sumFrom2A, sumFrom3, sumFrom3A, sumFrom4, sumFrom4A, sumFrom4B;
  
  wire [2:0] carrysOf1, carrysOf1A, carrysOf2, carrysOf2A, carrysOf3,carrysOf3A, carrysOf3B, carrysOf4, carrysOf4A, carrysOf4B, carrysOf4C, carrysOf5, carrysOf6, carrysOf7;
 
  wire [15:0] outSum;
  
  adder5 a1(a[3:0], b[3:0], c[3:0], d[3:0], e[3:0], sumOne);
  adder5 a2(a[7:4], b[7:4], c[7:4], d[7:4], e[7:4], sumTwo);
  adder5 a3(a[11:8], b[11:8], c[11:8], d[11:8], e[11:8], sumThree);
  adder5 a4(a[15:12], b[15:12], c[15:12], d[15:12], e[15:12], sumFour);
  
  dreg v1(clk, valid, valid1);
  dreg #(7) d1(clk, sumOne, sumOneA);
  dreg #(7) d2(clk, sumTwo, sumTwoA);
  dreg #(7) d3(clk, sumThree, sumThreeA);
  dreg #(7) d4(clk, sumFour, sumFourA);
  
  assign carrysOf1 = sumOneA[6:4];
  assign sum30 = sumOneA[3:0];	// sum[3:0]
  assign carrysOf2 = sumTwoA[6:4];
  assign sumFrom2 = sumTwoA[3:0];
  assign carrysOf3 = sumThreeA[6:4];
  assign sumFrom3 = sumThreeA[3:0];
  assign carrysOf4 = sumFourA[6:4];
  assign sumFrom4 = sumFourA[3:0];
  
  adder5 a5(carrysOf1, sumFrom2, 0, 0, 0, sumFive);
  
  dreg v2(clk, valid1, valid2);
  dreg #(7) d5(clk, sumFive, sumFiveA);
  dreg #(4) d6(clk, sum30, sum30A);
  dreg #(3) d7(clk, carrysOf2, carrysOf2A);
  dreg #(4) d8(clk, sumFrom3, sumFrom3A);
  dreg #(3) d9(clk, carrysOf3, carrysOf3A);
  dreg #(4) d10(clk, sumFrom4, sumFrom4A);
  dreg #(3) d11(clk, carrysOf4, carrysOf4A);
  
  assign sum74 = sumFiveA[3:0];	// sum[7:4]
  assign carrysOf5 = sumFiveA[6:4];
  
  adder5 a6(carrysOf5, sumFrom3A, carrysOf2A, 0, 0, sumSix);
  
  dreg v3(clk, valid2, valid3);
  dreg #(7) d12(clk, sumSix, sumSixA);
  dreg #(4) d13(clk, sum30A, sum30B);
  dreg #(4) d14(clk, sum74, sum74A);
  dreg #(3) d15(clk, carrysOf3A, carrysOf3B);
  dreg #(4) d16(clk, sumFrom4A, sumFrom4B);
  dreg #(3) d17(clk, carrysOf4A, carrysOf4B);
  
  assign sum118 = sumSixA[3:0];		// sum[11:8]
  assign carrysOf6 = sumSixA[6:4];
  
  adder5 a7(carrysOf6, carrysOf3B, sumFrom4B, 0, 0, sumSeven);
  
  dreg v4(clk, valid3, valid4);
  dreg #(7) d18(clk, sumSeven, sumSevenA); 
  dreg #(4) d19(clk, sum30B, sum30C);
  dreg #(4) d20(clk, sum74A, sum74B);
  dreg #(4) d21(clk, sum118, sum118A);
  dreg #(3) d22(clk, carrysOf4B, carrysOf4C);
  
  assign sum1512 = sumSevenA[3:0];	// sum[15:12]
  assign carrysOf7 = sumSevenA[6:4];
  
  adder5 a8(carrysOf7, carrysOf4C, 0, 0, 0, sumEight);
  
  dreg v5(clk, valid4, ready);
  dreg #(7) df(clk, sumEight, sumEightA);
  dreg #(4) d23(clk, sum30C, sum[3:0]);
  dreg #(4) d24(clk, sum74B, sum[7:4]);
  dreg #(4) d25(clk, sum118A, sum[11:8]);
  dreg #(4) d26(clk, sum1512, sum[15:12]);
  
  
  /*
  wire coA, coB,coC, coAA, coBB,coCC, coD, coDD, coE, coEE, coF, coFF, coG, coGG, coH, coHH, coI, coII, coJ, coJJ, coK, coKK, coL, coLL;
  wire [3:0] sumA, sumAA, sumAAA, sumAAAA, sumB, sumBB,sumBBB, sumC, sumCC, sumD;
  
  wire valid1, valid2, valid3, valid4;
  
  adder5carry a1(a[3:0], b[3:0], c[3:0], d[3:0], e[3:0], 0, 0, 0, coA, coB, coC, sumA); 
  
  dreg v1(clk, valid, valid1);
  dreg carry1(clk, coA, coAA);
  dreg carry2(clk, coB, coBB);
  dreg carry3(clk, coC, coCC);
  dreg #(4) sA(clk, sumA, sumAA);
  
  adder5carry a2(a[7:4], b[7:4], c[7:4], d[7:4], e[7:4], coAA, coBB, coCC, coD, coE, coF, sumB);
  
  dreg v2(clk, valid1, valid2);
  dreg carry4(clk, coD, coDD);
  dreg carry5(clk, coE, coEE);
  dreg carry6(clk, coF, coFF);
  dreg #(4) sAA(clk, sumAA, sumAAA);
  dreg #(4) sB(clk, sumB, sumBB);
  
  adder5carry a3(a[11:8], b[11:8], c[11:8], d[11:8], e[11:8], coDD, coEE, coFF, coG, coH, coI, sumC);
  
  dreg v3(clk, valid2, valid3);
  dreg carry7(clk, coG, coGG);
  dreg carry8(clk, coH, coHH);
  dreg carry9(clk, coI, coII);
  dreg #(4) sAAA(clk, sumAAA, sumAAAA);
  dreg #(4) sBB(clk, sumBB, sumBBB);
  dreg #(4) sC(clk, sumC, sumCC);
  
  adder5carry a4(a[15:12], b[15:12], c[15:12], d[15:12], e[15:12], coGG, coHH, coII, coJ, coK, coL, sumD);
  
  dreg v4(clk, valid3, ready);
  dreg carry10(clk, coJ, coJJ);
  dreg carry11(clk, coK, coKK);
  dreg carry12(clk, coL, coLL);
  dreg #(4) sAAAA(clk, sumAAAA, sum[3:0]);
  dreg #(4) sBBB(clk, sumBBB, sum[7:4]);
  dreg #(4) sCC(clk, sumCC, sum[11:8]);
  dreg #(4) sD(clk, sumD, sum[15:12]);
  
  
  */
  
  
  endmodule
  
  
  
  
  
 
  
  
  
  
  
                                                               

// 3.1c) Pipelined neuron
// 8 bit signed weights, bias (constant)
// 8 bit unsigned inputs 
// 1 bit input: new (when a set of inputs are available)
// 8 bit unsigned output 
// 1 bit output: ready (when the output is valid)
module neuron(clk, w1, w2, w3, w4, b, x1, x2, x3, x4, new, y, ready);
    input clk;
    input [7:0] w1, w2, w3, w4, b;  // signed 2s complement
    input [7:0] x1, x2, x3, x4;     // unsigned
    input new;
    output [7:0] y;                 // unsigned
    output ready;
  
  wire [7:0]  yin;
  wire [15:0] bT, bOut, prod1, prod2, prod3, prod4, prod1Out, prod2Out, prod3Out, prod4Out, sum;
    wire readyIn, ready1, ready2, ready3, ready4, ready1Out, ready2Out, ready3Out, ready4Out, mulReady, mulqReady, mulwReady, mulReady2;

    multiply 	m1(clk, w1, x1, new, prod1, ready1);
    multiply 	m2(clk, w2, x2, new, prod2, ready2);
    multiply 	m3(clk, w3, x3, new, prod3, ready3);
    multiply 	m4(clk, w4, x4, new, prod4, ready4);
  
  assign bT = {{8{b[7]}}, b};
  
  
  //dreg #(16) d0(clk, bT, bOut);
  /* dreg d1(clk, ready1, ready1Out);
  dreg d2(clk, ready2, ready2Out);
  dreg d3(clk, ready3, ready3Out);
  dreg d4(clk, ready4, ready4Out);
  dreg #(16) d5(clk, prod1, prod1Out);
  dreg #(16) d6(clk, prod2, prod2Out);
  dreg #(16) d7(clk, prod3, prod3Out);
  dreg #(16) d8(clk, prod4, prod4Out); */
  
  
  //assign mulReady = (ready1 && ready2 && ready3 && ready4) ? 1 : 0;
  
  //dreg d100(clk, (ready1 && ready2 && ready3 && ready4) ? 1 : 0, mulqReady);
 //dreg d101(clk, mulqReady, mulwReady);
  //dreg d101(clk, mulqReady ? 0 : ((ready1 && ready2 && ready3 && ready4) ? 1 : 0), mulReady);
  assign mulReady = /*mulqReady ? 0 :*/ (ready1 && ready2 && ready3 && ready4) ? 1 : 0;
  
  //dreg dmul(clk, mulReady, mulReady2);
 
  piped_adder		add(clk, prod1, prod2, prod3, prod4, bT, mulReady, sum, readyIn);
  
  //dreg d50(clk, new ? 0: readyIn, valid);
  
  relu			relu(sum, yin);
  
  //dreg d9(clk, new ? 0 : (readyIn & mulReady) ? 1 : 0, ready);
  //assign ready = new ? 0 : (readyIn) ? 1 : 0;
  dreg red (clk,/* new ? 0 : */ readyIn, ready);
  dreg #(8) dy(clk, yin, y); 
  
  
endmodule
