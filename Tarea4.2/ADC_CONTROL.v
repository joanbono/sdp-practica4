// --------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2013 - 2014
// --------------------------------------------------------------------
// Nombre del archivo: LCD_SYNC.v
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
//
// --------------------------------------------------------------------
// Version: V1.0 | Fecha Modificacion: 29/05/2014
//
// Autor: Joan Bono Aguilar && Dario Alandes Codina
// Ordenador de trabajo: DISE06 
// --------------------------------------------------------------------



module ADC_CONTROL(
					iCLK,
					iRST_n,
					oADC_DIN,
					oADC_DCLK,
					oADC_CS,
					iADC_DOUT,
					iADC_BUSY,
					iADC_PENIRQ_n,
					oTOUCH_IRQ,
					oX_COORD,
					oY_COORD
					);

parameter SYSCLK_FRQ	= 50000000;
parameter ADC_DCLK_FRQ	= 1000000;
parameter ADC_DCLK_CNT	= SYSCLK_FRQ/(ADC_DCLK_FRQ*2);

input					iCLK;
input					iRST_n;
input					iADC_DOUT;
input					iADC_PENIRQ_n;
input					iADC_BUSY;
output reg				oADC_DIN;
output reg				oADC_DCLK=1'b0;
output reg				oADC_CS=1'b0;
output					oTOUCH_IRQ;
output reg	[11:0]	oX_COORD;
output reg	[11:0]	oY_COORD;

wire TC, NCLK;

reg [6:0]count=0;
reg ultimo=1'b0;
parameter [7:0] X=8'b10010010, Y=8'b11010010;

pll pll_inst (.inclk0 ( iCLK ), .c0 ( NCLK)); //Creamos el reloj del sistema a 25MHz

contador8bitsparam #(.fin_cuenta(50))cont ( .clock (NCLK), .reset (1'b1), .enable (oADC_CS), .load (1'b1), .modo (1'b1), .TC (TC));

//Bloque para activar/desactivar oADC_CS					
always@(posedge NCLK)													
begin																			
	if (oADC_CS==1'b0 && iADC_PENIRQ_n==1'b0) begin oADC_CS=1'b1; ultimo=1'b0; end		
	else if (ultimo && oADC_CS==1'b1) begin oADC_CS=1'b0; oADC_DCLK=1'b0; end			

//Bloque para crear ADC_DCLK y count									
																			
	if(TC==1'b1)																
	begin
		oADC_DCLK=!oADC_DCLK;  		//Creamos en ADC_DCLK										
		if(count==79)begin count=0; ultimo=1'b1; end		//Creamos el contador de semiciclos	
		else count=count+1'b1;
	end																		
end																				

//Bloque para controlar ADC_DIN
always@(posedge NCLK)
begin
	case(count)
		0:oADC_DIN=X[7];
		1:oADC_DIN=X[7];
		2:oADC_DIN=X[6];
		3:oADC_DIN=X[6];
		4:oADC_DIN=X[5];
		5:oADC_DIN=X[5];
		6:oADC_DIN=X[4];
		7:oADC_DIN=X[4];
		8:oADC_DIN=X[3];
		9:oADC_DIN=X[3];
		10:oADC_DIN=X[2];
		11:oADC_DIN=X[2];
		12:oADC_DIN=X[1];
		13:oADC_DIN=X[1];
		14:oADC_DIN=X[0];
		15:oADC_DIN=X[0];
					
		32:oADC_DIN=Y[7];
		33:oADC_DIN=Y[7];
		34:oADC_DIN=Y[6];
		35:oADC_DIN=Y[6];
		36:oADC_DIN=Y[5];
		37:oADC_DIN=Y[5];
		38:oADC_DIN=Y[4];
		39:oADC_DIN=Y[4];
		40:oADC_DIN=Y[3];
		41:oADC_DIN=Y[3];
		42:oADC_DIN=Y[2];
		43:oADC_DIN=Y[2];
		44:oADC_DIN=Y[1];
		45:oADC_DIN=Y[1];
		46:oADC_DIN=Y[0];
		47:oADC_DIN=Y[0];
	default oADC_DIN=0;
	endcase
end

//Bloque para recibir ADC_DOUT
always @(posedge NCLK)
if(oADC_CS)
begin
	case(count)
		19:oX_COORD[11]=iADC_DOUT;
		21:oX_COORD[10]=iADC_DOUT;
		23:oX_COORD[9]=iADC_DOUT;
		25:oX_COORD[8]=iADC_DOUT;
		27:oX_COORD[7]=iADC_DOUT;
		29:oX_COORD[6]=iADC_DOUT;
		31:oX_COORD[5]=iADC_DOUT;
		33:oX_COORD[4]=iADC_DOUT;
		35:oX_COORD[3]=iADC_DOUT;
		37:oX_COORD[2]=iADC_DOUT;
		39:oX_COORD[1]=iADC_DOUT;
		41:oX_COORD[0]=iADC_DOUT;
			
		51:oY_COORD[11]=iADC_DOUT;
		53:oY_COORD[10]=iADC_DOUT;
		55:oY_COORD[9]=iADC_DOUT;
		57:oY_COORD[8]=iADC_DOUT;
		59:oY_COORD[7]=iADC_DOUT;
		61:oY_COORD[6]=iADC_DOUT;
		63:oY_COORD[5]=iADC_DOUT;
		65:oY_COORD[4]=iADC_DOUT;
		67:oY_COORD[3]=iADC_DOUT;
		69:oY_COORD[2]=iADC_DOUT;
		71:oY_COORD[1]=iADC_DOUT;
		73:oY_COORD[0]=iADC_DOUT;
	endcase
end
	
endmodule
