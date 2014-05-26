

// --------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2013 - 2014
// --------------------------------------------------------------------
// Nombre del archivo: tactil_7seg.v
//
// Descripcion: Este codigo Verilog sirve para gestionar una conexión serie con un convertidor analógico digital:
//     iCLK,   Reloj de entrada al sistema de 50 Mhz
//		iRST_n,  Reset del convertidor , 
//		oADC_DIN,  datos que se envian a el convertidor para solicitar las coordenadas.
//		oADC_DCLK, reloj de salida que controla el convertidor ADC.
//		oADC_CS,   señal de enable, activa a nivel alto.
//		iADC_DOUT, señal serie para recibir las coordenadas 
//		iADC_PENIRQ_n, señal de disparo, activa a nivel bajo, que inicia la comunicación.	
//		oX_COORD, salida de la coordenada x
//		oY_COORD,  salida de la coordenada y
//    iADC_BUSY, oTOUCH_IRQ,
//    HEX7, HEX6, HEX5, HEX2, HEX1, HEX0, salidas de las coordenadas de la pantalla táctil por las 3 primeras y 3 últimas pantallas de 7 segmentos en hexadecimal.

// --------------------------------------------------------------------
// Version: V1.0 | Fecha Modificacion: 29/05/2014
//
// Autor: Joan Bono && Dario Alandes
// Ordenador de trabajo: DISE13 



module tactil_7seg(iCLK,iRST_n,oADC_DIN,oADC_DCLK,oADC_CS,iADC_DOUT,iADC_BUSY,iADC_PENIRQ_n,oTOUCH_IRQ,HEX7, HEX6, HEX5, HEX2, HEX1, HEX0);
input					iCLK;
input					iRST_n;
input					iADC_DOUT;
input					iADC_PENIRQ_n;
input					iADC_BUSY;
output 				oADC_DIN;
output 				oADC_DCLK;
output				oADC_CS;
output					oTOUCH_IRQ;
output  [6:0] HEX7, HEX6, HEX5, HEX2, HEX1, HEX0;
wire	[11:0]	oX_COORD;
wire	[11:0]	oY_COORD;
wire NCLK;


ADC_CONTROL (.iCLK(iCLK),.iRST_n(iRST_n),.oADC_DIN(oADC_DIN),.oADC_DCLK(oADC_DCLK),.oADC_CS(oADC_CS),.iADC_DOUT(iADC_DOUT),.iADC_BUSY(iADC_BUSY),.iADC_PENIRQ_n(iADC_PENIRQ_n),
				.oTOUCH_IRQ(oTOUCH_IRQ),.oX_COORD(oX_COORD),.oY_COORD(oY_COORD), .NCLK(NCLK));

traductor(.entrada(oX_COORD[11:8]), .sal(HEX2), .reloj(NCLK));
traductor(.entrada(oX_COORD[7:4]), .sal(HEX1), .reloj(NCLK));
traductor(.entrada(oX_COORD[3:0]), .sal(HEX0), .reloj(NCLK));
traductor(.entrada(oY_COORD[11:8]), .sal(HEX7), .reloj(NCLK));
traductor(.entrada(oY_COORD[7:4]), .sal(HEX6), .reloj(NCLK));
traductor(.entrada(oY_COORD[3:0]), .sal(HEX5), .reloj(NCLK));

endmodule
