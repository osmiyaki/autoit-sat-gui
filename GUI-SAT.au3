#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <wd_core.au3>
#include <wd_helper.au3>
#include <File.au3>
#include <Array.au3>
#include "data\credentials.au3"

;GUI
Local $hGUI
Local $idTipoFactura, $idCliente, $idUsoCFDI, _
		$idSerie, $idFolio, _
		$idNumId, $idDescripcion, _
		$idClaveSAT, $idClaveUnidad, $idCantidad, $idValorUni, _
		$idImpuesto, $idTasa, $idFactSola, $idFactCSV
Local $idTipo_Comp, $idCliente_Comp, $idSerie_Comp, $idFolio_Comp, _
		$idCFDI, $idFechaPago, $idFormaPago, $idMoneda, _
		$idTipo_Cambio, $idMonto, $idNumOp, $idBanco_Emi, _
		$idRFC_Emi, $idCuenta_Ord, $idBanco_Ben, $idRFC_Ben, _
		$idCuenta_Ben, $idTipo_Cadena, $idCert, $idCadena, _
		$idSello, $idParcialidad, $idSaldo_Ant, $idImporte, $idSaldo_Ins
Local $idRadio_HD, $idRadio_SD

#Region GUI_Size
Local $aGUI[3][2] = [[480, 350], [10, 10], [10, 10]]
$aGUI[2][0] = $aGUI[0][0] - 20
$aGUI[2][1] = $aGUI[0][1] - 20
Local $aPos[4]
#EndRegion GUI_Size

#Region Fact_Pos
Local $iInput_W_Fact = 140
Local $iInput_H_Fact = 20

Local $aGUI_Label_Fact[][2] = [[20, 40], [170, 40], [320, 40], _
		[20, 90], [170, 90], _
		[20, 140], [170, 140], [320, 140], _
		[20, 190], [170, 190], _
		[20, 240], [170, 240], [320, 240]]

Local $aGUI_Input_Fact[][2] = [[20, 55], [170, 55], [320, 55], _
		[20, 105], [170, 105], _
		[20, 155], [170, 155], [320, 155], _
		[20, 205], [170, 205], _
		[20, 255], [170, 255], [320, 255], _
		[20, 285], [170, 285]]
		
Local $aGUI_Btn_Fact[][2] = [[20, 310], [170, 310], [320, 310]]
#EndRegion Fact_Pos

#Region Comp_Pos
Local $iInput_W_Comp = 140
Local $iInput_H_Comp = 20

Local $aGUI_Label_Comp[][2] = [[20, 40], [170, 40], [320, 40], [470, 40], _
		[20, 90], [320, 90], [470, 90], _
		[20, 140], [170, 140], [320, 140], [470, 140], _
		[20, 190], [170, 190], [320, 190], _
		[20, 240], [170, 240], [320, 240], _
		[20, 290], [170, 290], [320, 290], [470, 290], _
		[20, 340], [170, 340], [320, 340], [470, 340], _
		[20, 390], [170, 390], [320, 390]]

Local $aGUI_Input_Comp[][2] = [[20, 55], [170, 55], [320, 55], [470, 55], _
		[20, 105], [320, 105], [470, 105], _
		[20, 155], [170, 155], [320, 155], [470, 155], _
		[20, 205], [170, 205], [320, 205], _
		[20, 255], [170, 255], [320, 255], _
		[20, 305], [170, 305], [320, 305], [470, 305], _
		[20, 355], [170, 355], [320, 355], [470, 355], _
		[20, 405], [170, 405], [320, 405]]

Local $aGUI_Btn_Comp[][2] = [[235, 390]]
#EndRegion Comp_Pos

#Region Config_Pos
Local $iInput_W_Config = 140
Local $iInput_H_Config = 20

Local $aGUI_Label_Config[][2] = [[20, 40], [170, 40], [320, 40], [470, 40], _
		[20, 90], [320, 90], [470, 90], _
		[20, 140], [170, 140], [320, 140], [470, 140], _
		[20, 190], [170, 190], [320, 190], _
		[20, 240], [170, 240], [320, 240], _
		[20, 290], [170, 290], [320, 290], [470, 290], _
		[20, 340], [170, 340], [320, 340], [470, 340], _
		[20, 390], [170, 390], [320, 390]]

Local $aGUI_Input_Config[][2] = [[20, 55], [170, 55], [320, 55], [470, 55], _
		[20, 105], [320, 105], [470, 105], _
		[20, 155], [170, 155], [320, 155], [470, 155], _
		[20, 205], [170, 205], [320, 205], _
		[20, 255], [170, 255], [320, 255], _
		[20, 305], [170, 305], [320, 305], [470, 305], _
		[20, 355], [170, 355], [320, 355], [470, 355], _
		[20, 405], [170, 405], [320, 405]]

Local $aGUI_Btn_Config[][2] = [[100, 100]]
#EndRegion Config_Pos

;Credenciales
Local $PACSAT, $CerFile, $KeyFile, $PassFIEL

;Campos
Local $sCliente, $sSerie, $iFolio, _
		$iNumId, $sDescripcion, _
		$iClaveSAT, $sClaveUnidad, $sUnidad, $iCantidad, _
		$iValorUni, $sImpuesto, $iTasa

Local $sTipoFactura

;WebDriver Variables
Local $sElement, $aElements, $sValue
Local $sSession, $sDesiredCapabilities
Local $bSAT = False
Local $bNFact = True
Local $bNCon = False
Local $WaitTime = 600

;DEBUG
;~ $_WD_DEBUG = $_WD_DEBUG_None
;~ $_WD_DEBUG = $_WD_DEBUG_Info
$_WD_DEBUG = $_WD_DEBUG_Error

GUI()

Func GUI()
	#Region GUI
	$hGUI = GUICreate("Inicio", $aGUI[0][0], $aGUI[0][1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
	#EndRegion GUI

	#Region Tab_Factura
	$idTab = GUICtrlCreateTab($aGUI[1][0], $aGUI[1][1], $aGUI[2][0], $aGUI[2][1])
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateTabItem("Factura")

	#Region Labels Factura
	GUICtrlCreateLabel("Tipo de Factura:", $aGUI_Label_Fact[0][0], $aGUI_Label_Fact[0][1])
	GUICtrlCreateLabel("Cliente:", $aGUI_Label_Fact[1][0], $aGUI_Label_Fact[1][1])
	GUICtrlCreateLabel("Uso de la Factura:", $aGUI_Label_Fact[2][0], $aGUI_Label_Fact[2][1])
	GUICtrlCreateLabel("Serie:", $aGUI_Label_Fact[3][0], $aGUI_Label_Fact[3][1])
	GUICtrlCreateLabel("Folio:", $aGUI_Label_Fact[4][0], $aGUI_Label_Fact[4][1])
	GUICtrlCreateLabel("Clave SAT:", $aGUI_Label_Fact[5][0], $aGUI_Label_Fact[5][1])
	GUICtrlCreateLabel("Clave Unidad:", $aGUI_Label_Fact[6][0], $aGUI_Label_Fact[6][1])
	GUICtrlCreateLabel("Cantidad:", $aGUI_Label_Fact[7][0], $aGUI_Label_Fact[7][1])
	GUICtrlCreateLabel("# de Identificación:", $aGUI_Label_Fact[8][0], $aGUI_Label_Fact[8][1])
	GUICtrlCreateLabel("Descripción:", $aGUI_Label_Fact[9][0], $aGUI_Label_Fact[9][1])
	GUICtrlCreateLabel("Valor Unitario:", $aGUI_Label_Fact[10][0], $aGUI_Label_Fact[10][1])
	GUICtrlCreateLabel("Impuesto:", $aGUI_Label_Fact[11][0], $aGUI_Label_Fact[11][1])
	GUICtrlCreateLabel("Tasa:", $aGUI_Label_Fact[12][0], $aGUI_Label_Fact[12][1])
	#EndRegion Labels Factura

	#Region Input Factura
	$idTipoFactura = GUICtrlCreateCombo("I Ingreso", $aGUI_Input_Fact[0][0], $aGUI_Input_Fact[0][1], $iInput_W_Fact, $iInput_H_Fact)
	$idCliente = GUICtrlCreateCombo("Nazario", $aGUI_Input_Fact[1][0], $aGUI_Input_Fact[1][1], $iInput_W_Fact, $iInput_H_Fact)
	$idUsoCFDI = GUICtrlCreateCombo("P01 Por Definir", $aGUI_Input_Fact[2][0], $aGUI_Input_Fact[2][1], $iInput_W_Fact, $iInput_H_Fact)
	$idSerie = GUICtrlCreateInput("AAA", $aGUI_Input_Fact[3][0], $aGUI_Input_Fact[3][1], $iInput_W_Fact, $iInput_H_Fact + 1)
	$idFolio = GUICtrlCreateInput("", $aGUI_Input_Fact[4][0], $aGUI_Input_Fact[4][1], $iInput_W_Fact, $iInput_H_Fact + 1)
	$idClaveSAT = GUICtrlCreateInput("", $aGUI_Input_Fact[5][0], $aGUI_Input_Fact[5][1], $iInput_W_Fact, $iInput_H_Fact + 1)
;~ 	$idClaveUnidad = GUICtrlCreateCombo("E48 Unidad de servicio", $aGUI_Input_Fact[6][0], $aGUI_Input_Fact[6][1], $iInput_W_Fact, $iInput_H_Fact)
	$idClaveUnidad = GUICtrlCreateInput("E48 Unidad de servicio", $aGUI_Input_Fact[6][0], $aGUI_Input_Fact[6][1], $iInput_W_Fact, $iInput_H_Fact)
	$idCantidad = GUICtrlCreateInput("1", $aGUI_Input_Fact[7][0], $aGUI_Input_Fact[7][1], $iInput_W_Fact, $iInput_H_Fact + 1)
;~ 	$idNumId = GUICtrlCreateCombo("", $aGUI_Input_Fact[8][0], $aGUI_Input_Fact[8][1], $iInput_W_Fact, $iInput_H_Fact)
	$idNumId = GUICtrlCreateInput("", $aGUI_Input_Fact[8][0], $aGUI_Input_Fact[8][1], $iInput_W_Fact, $iInput_H_Fact)
;~ 	$idDescripcion = GUICtrlCreateCombo("", $aGUI_Input_Fact[9][0], $aGUI_Input_Fact[9][1], $iInput_W_Fact * 2 + 10, $iInput_H_Fact)
	$idDescripcion = GUICtrlCreateInput("", $aGUI_Input_Fact[9][0], $aGUI_Input_Fact[9][1], $iInput_W_Fact * 2 + 10, $iInput_H_Fact)
	$idValorUni = GUICtrlCreateInput("", $aGUI_Input_Fact[10][0], $aGUI_Input_Fact[10][1], $iInput_W_Fact, $iInput_H_Fact + 1)
;~ 	$idImpuesto = GUICtrlCreateCombo("IVA", $aGUI_Input_Fact[11][0], $aGUI_Input_Fact[11][1], $iInput_W_Fact, $iInput_H_Fact)
	$idImpuesto = GUICtrlCreateInput("IVA", $aGUI_Input_Fact[11][0], $aGUI_Input_Fact[11][1], $iInput_W_Fact, $iInput_H_Fact)
;~ 	$idTasa = GUICtrlCreateCombo("16%", $aGUI_Input_Fact[12][0], $aGUI_Input_Fact[12][1], $iInput_W_Fact, $iInput_H_Fact)
	$idTasa = GUICtrlCreateInput("16%", $aGUI_Input_Fact[12][0], $aGUI_Input_Fact[12][1], $iInput_W_Fact, $iInput_H_Fact)
	GUIStartGroup()
	$idFactSola = GUICtrlCreateRadio("Factura Sola", $aGUI_Input_Fact[13][0], $aGUI_Input_Fact[13][1], $iInput_W_Fact, $iInput_H_Fact)
	$idFactCSV = GUICtrlCreateRadio("Facturas con CSV", $aGUI_Input_Fact[14][0], $aGUI_Input_Fact[14][1], $iInput_W_Fact, $iInput_H_Fact)
	GUICtrlSetState($idFactSola, $GUI_CHECKED)
	#EndRegion Input Factura

	#Region Button Factura
	$idIniciarBtn = GUICtrlCreateButton('Iniciar Factura', $aGUI_Btn_Fact[0][0], $aGUI_Btn_Fact[0][1], $iInput_W_Fact, $iInput_H_Fact + 1)
	$idAgregarBtn = GUICtrlCreateButton('Agregar Articulo', $aGUI_Btn_Fact[1][0], $aGUI_Btn_Fact[1][1], $iInput_W_Fact, $iInput_H_Fact + 1)
	$idSellarBtn = GUICtrlCreateButton('Sellar Factura', $aGUI_Btn_Fact[2][0], $aGUI_Btn_Fact[2][1], $iInput_W_Fact, $iInput_H_Fact + 1)
	#EndRegion Button Factura

	#Region Add Data
	#comments-start
	GUICtrlSetData($idTipoFactura, 'E Egreso')
	GUICtrlSetData($idTipoFactura, 'N Nómina')
	GUICtrlSetData($idTipoFactura, 'P Pago')
	GUICtrlSetData($idTipoFactura, 'T Traslado')
	GUICtrlSetData($idCliente, 'Publico en General')
	GUICtrlSetData($idCliente, 'Misesa')
	GUICtrlSetData($idCliente, 'Dago')
	GUICtrlSetData($idCliente, 'Nidia Edith')
	GUICtrlSetData($idCliente, 'SE1953')
	GUICtrlSetData($idCliente, 'Santa Elena')
	GUICtrlSetData($idCliente, 'Segana')
	GUICtrlSetData($idCliente, 'Mercato')
	GUICtrlSetData($idCliente, 'Davila')
	GUICtrlSetData($idUsoCFDI, 'G03 Gastos en General')
;~ 	GUICtrlSetData($idClaveUnidad, "H87 Pieza")
	#comments-end
	#EndRegion Add Data
	#EndRegion Tab_Factura

	#Region Tab_Complemento
	$idTab_Complemento = GUICtrlCreateTabItem("Complemento")
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	#Region Labels_Complemento
	GUICtrlCreateLabel("Tipo de Factura:", $aGUI_Label_Comp[0][0], $aGUI_Label_Comp[0][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Cliente:", $aGUI_Label_Comp[1][0], $aGUI_Label_Comp[1][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Serie:", $aGUI_Label_Comp[2][0], $aGUI_Label_Comp[2][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Folio:", $aGUI_Label_Comp[3][0], $aGUI_Label_Comp[3][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("CFDI Relacionado:", $aGUI_Label_Comp[4][0], $aGUI_Label_Comp[4][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Fecha de Pago:", $aGUI_Label_Comp[5][0], $aGUI_Label_Comp[5][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Forma de Pago:", $aGUI_Label_Comp[6][0], $aGUI_Label_Comp[6][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Moneda:", $aGUI_Label_Comp[7][0], $aGUI_Label_Comp[7][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Tipo de Cambio:", $aGUI_Label_Comp[8][0], $aGUI_Label_Comp[8][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Monto:", $aGUI_Label_Comp[9][0], $aGUI_Label_Comp[9][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Número de Operación:", $aGUI_Label_Comp[10][0], $aGUI_Label_Comp[10][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Nombre de banco:", $aGUI_Label_Comp[11][0], $aGUI_Label_Comp[11][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("RFC emisor de cuenta origen:", $aGUI_Label_Comp[12][0], $aGUI_Label_Comp[12][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Cuenta ordenante:", $aGUI_Label_Comp[13][0], $aGUI_Label_Comp[13][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Nombre de banco:", $aGUI_Label_Comp[14][0], $aGUI_Label_Comp[14][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("RFC emisor cuenta beneficiaria:", $aGUI_Label_Comp[15][0], $aGUI_Label_Comp[15][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Cuenta beneficiario:", $aGUI_Label_Comp[16][0], $aGUI_Label_Comp[16][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Tipo cadena de pago:", $aGUI_Label_Comp[17][0], $aGUI_Label_Comp[17][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Certificado de pago:", $aGUI_Label_Comp[18][0], $aGUI_Label_Comp[18][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Cadena de pago:", $aGUI_Label_Comp[19][0], $aGUI_Label_Comp[19][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Sello de pago:", $aGUI_Label_Comp[20][0], $aGUI_Label_Comp[20][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Número de parcialidad:", $aGUI_Label_Comp[21][0], $aGUI_Label_Comp[21][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Importe de saldo anterior:", $aGUI_Label_Comp[22][0], $aGUI_Label_Comp[22][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Importe pagado:", $aGUI_Label_Comp[23][0], $aGUI_Label_Comp[23][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlCreateLabel("Importe de saldo insoluto:", $aGUI_Label_Comp[24][0], $aGUI_Label_Comp[24][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	#EndRegion Labels_Complemento

	#Region Input Complemento
	$idTipo_Comp = GUICtrlCreateCombo("P Pago", $aGUI_Input_Comp[0][0], $aGUI_Input_Comp[0][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idCliente_Comp = GUICtrlCreateCombo('Nazario', $aGUI_Input_Comp[1][0], $aGUI_Input_Comp[1][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idSerie_Comp = GUICtrlCreateInput("CRP", $aGUI_Input_Comp[2][0], $aGUI_Input_Comp[2][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idFolio_Comp = GUICtrlCreateInput("", $aGUI_Input_Comp[3][0], $aGUI_Input_Comp[3][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idCFDI = GUICtrlCreateInput("", $aGUI_Input_Comp[4][0], $aGUI_Input_Comp[4][1], $iInput_W_Comp * 2 + 10, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idFechaPago = GUICtrlCreateInput("", $aGUI_Input_Comp[5][0], $aGUI_Input_Comp[5][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	;Agregar Menu Desplegable con las formas de pago
	$idFormaPago = GUICtrlCreateCombo("03 Transferencia electrónica de fondos (incluye SPEI)", $aGUI_Input_Comp[6][0], $aGUI_Input_Comp[6][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	;Agregar Menu Desplegable con las monedas
	$idMoneda = GUICtrlCreateCombo("MXN Peso Mexicano", $aGUI_Input_Comp[7][0], $aGUI_Input_Comp[7][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idTipo_Cambio = GUICtrlCreateInput("", $aGUI_Input_Comp[8][0], $aGUI_Input_Comp[8][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idMonto = GUICtrlCreateInput("", $aGUI_Input_Comp[9][0], $aGUI_Input_Comp[9][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idNumOp = GUICtrlCreateInput("", $aGUI_Input_Comp[10][0], $aGUI_Input_Comp[10][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idBanco_Emi = GUICtrlCreateCombo("Banorte", $aGUI_Input_Comp[11][0], $aGUI_Input_Comp[11][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idRFC_Emi = GUICtrlCreateInput("BMN930209927", $aGUI_Input_Comp[12][0], $aGUI_Input_Comp[12][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idCuenta_Ord = GUICtrlCreateInput("", $aGUI_Input_Comp[13][0], $aGUI_Input_Comp[13][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idBanco_Ben = GUICtrlCreateCombo("HSBC", $aGUI_Input_Comp[14][0], $aGUI_Input_Comp[14][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idRFC_Ben = GUICtrlCreateInput("HMI950125KG8", $aGUI_Input_Comp[15][0], $aGUI_Input_Comp[15][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idCuenta_Ben = GUICtrlCreateInput("021060064724500346", $aGUI_Input_Comp[16][0], $aGUI_Input_Comp[16][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	;Agregar botones de opcion seleccionar complemento con o sin cadena de pago
	$idTipo_Cadena = GUICtrlCreateCombo("01 SPEI", $aGUI_Input_Comp[17][0], $aGUI_Input_Comp[17][1], $iInput_W_Comp, $iInput_H_Comp)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idCert = GUICtrlCreateInput("00001000000414389247", $aGUI_Input_Comp[18][0], $aGUI_Input_Comp[18][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idCadena = GUICtrlCreateInput("", $aGUI_Input_Comp[19][0], $aGUI_Input_Comp[19][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idSello = GUICtrlCreateInput("", $aGUI_Input_Comp[20][0], $aGUI_Input_Comp[20][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idParcialidad = GUICtrlCreateInput("1", $aGUI_Input_Comp[21][0], $aGUI_Input_Comp[21][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idSaldo_Ant = GUICtrlCreateInput("", $aGUI_Input_Comp[22][0], $aGUI_Input_Comp[22][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idImporte = GUICtrlCreateInput("", $aGUI_Input_Comp[23][0], $aGUI_Input_Comp[23][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idSaldo_Ins = GUICtrlCreateInput("0.00", $aGUI_Input_Comp[24][0], $aGUI_Input_Comp[24][1], $iInput_W_Comp, $iInput_H_Comp + 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	#EndRegion Input Complemento

	#Region Button Complemento
	$idButton_Comp = GUICtrlCreateButton("Realizar Complemento", $aGUI_Btn_Comp[0][0], $aGUI_Btn_Comp[0][1], 180, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	#EndRegion Button Complemento

	#Region Add Data
	GUICtrlSetData($idTipo_Comp, 'I Ingreso')
	GUICtrlSetData($idTipo_Comp, 'E Egreso')
	GUICtrlSetData($idTipo_Comp, 'N Nómina')
	GUICtrlSetData($idTipo_Comp, 'T Traslado')
	GUICtrlSetData($idCliente_Comp, 'Publico en General')
	GUICtrlSetData($idCliente_Comp, 'Misesa')
	GUICtrlSetData($idCliente_Comp, 'Dago')
	GUICtrlSetData($idCliente_Comp, 'Nidia Edith')
	GUICtrlSetData($idCliente_Comp, 'SE1953')
	GUICtrlSetData($idCliente_Comp, 'Santa Elena')
	GUICtrlSetData($idCliente_Comp, 'Segana')
	GUICtrlSetData($idCliente_Comp, 'Mercato')
	GUICtrlSetData($idCliente_Comp, 'Davila')
	#EndRegion Add Data
	#EndRegion Tab_Complemento

	#Region Tab Config
	$idTab_Complemento = GUICtrlCreateTabItem("Configuración")
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	#Region Labels
	GUICtrlCreateGroup("Lugar", $aGUI_Label_Config[0][0], $aGUI_Label_Config[0][1], $iInput_W_Config - 40, 60)
;~ 	GUICtrlCreateLabel("Tipo de Factura:", $aGUI_Label_Comp[0][0], $aGUI_Label_Comp[0][1])
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
;~ 	GUICtrlCreateLabel("Cliente:", $aGUI_Label_Comp[1][0], $aGUI_Label_Comp[1][1])
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	#EndRegion Labels

	#Region Input
;~ 	$idTipo_Comp = GUICtrlCreateCombo("P Pago", $aGUI_Input_Comp[0][0], $aGUI_Input_Comp[0][1], $iInput_W_Comp, $iInput_H_Comp)
;~ 	GUICtrlCreateGroup("Group 1", $aGUI_Input_Comp[0][0], $aGUI_Input_Comp[0][1], $iInput_W_Comp, $iInput_H_Comp)
	GUIStartGroup()
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$idRadio_HD = GUICtrlCreateRadio("1920 x 1080", 5 + $aGUI_Input_Config[0][0], $aGUI_Input_Config[0][1], $iInput_W_Config - 50, $iInput_H_Config)
	$idRadio_SD = GUICtrlCreateRadio("1366 × 466", 5 + $aGUI_Input_Config[0][0], $aGUI_Input_Config[0][1] + 20, $iInput_W_Config - 50, $iInput_H_Config)
;~ 	$idRadio_Dell = GUICtrlCreateRadio("Dell (1440 x 900)", 5 + $aGUI_Input_Config[0][0], $aGUI_Input_Config[0][1] + 40, $iInput_W_Config - 50, $iInput_H_Config)
;~ 	GUICtrlSetState($idRadio_HD, $GUI_CHECKED)
	GUICtrlSetState($idRadio_SD, $GUI_CHECKED)
;~ 	GUICtrlSetState($idRadio_Dell, $GUI_CHECKED)
	#EndRegion Input

	#Region Button Complemento
	$idButton_Config = GUICtrlCreateButton("Checar", $aGUI_Btn_Config[0][0], $aGUI_Btn_Config[0][1], 180, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	#EndRegion Button Complemento
	#EndRegion Tab Config

	GUICtrlCreateTabItem("")
	#Region GUI Handler
	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				If $bSAT = True Then
					_WD_DeleteSession($sSession)
;~ 					_WD_Shutdown()
				EndIf
				_WD_Shutdown()
				Exit
			Case $idTab
				Switch GUICtrlRead($idTab)
					Case 0
						;$aPos = WinGetPos($hGUI)
						WinMove($hGUI, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
					Case 1
						$aPos = WinGetPos($hGUI)
						WinMove($hGUI, "", $aPos[0], $aPos[1], 650, 470)
				EndSwitch
			Case $idIniciarBtn
				If GUICtrlRead($idFactSola) = 1 Then
					Iniciar_Fact()
					Agregar_Art()
				EndIf
				If GUICtrlRead($idFactCSV) = 1 Then
					CSV_Fact()
				EndIf
				GUISetState(@SW_RESTORE)
			Case $idAgregarBtn
				If GUICtrlRead($idFactSola) = 1 Then
					Agregar_Art()
				EndIf
				GUISetState(@SW_RESTORE)
			Case $idSellarBtn
				If GUICtrlRead($idFactSola) = 1 Then
					Sellar_Fact()
				EndIf
				GUISetState(@SW_RESTORE)
			Case $idButton_Comp
				CSV_Comp()
;~ 				Complemento()
				GUISetState(@SW_RESTORE)
			Case $idButton_Config
				GUISetState(@SW_RESTORE)
			Case $idFolio
				GUICtrlSetData($idFolio, '10001' & GUICtrlRead($idFolio))
			Case $idFolio_Comp
				GUICtrlSetData($idFolio_Comp, '10001' & GUICtrlRead($idFolio_Comp))
			Case $idMonto
				GUICtrlSetData($idSaldo_Ant, GUICtrlRead($idMonto))
				GUICtrlSetData($idImporte, GUICtrlRead($idMonto))
		EndSwitch
	WEnd
	#EndRegion GUI Handler
EndFunc   ;==>GUI

Func Init_Webdriver()
	SetupChrome()
	_WD_Startup()

	If @error <> $_WD_ERROR_Success Then
		Exit -1
	EndIf

	$sSession = _WD_CreateSession($sDesiredCapabilities)

	If @error = $_WD_ERROR_Success Then
		IniciarSAT()
	EndIf
	;Fin()
EndFunc   ;==>Init_Webdriver

Func SetupChrome()
	_WD_Option('Driver', $sChromeDrvPath)
	_WD_Option('Port', 9515)
	_WD_Option('DriverParams', '--log-path="' & @ScriptDir & '\chrome.log"')
	$sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true, "args":["start-maximized --unsafely-treat-insecure-origin-as-secure"]}}}}'
EndFunc   ;==>SetupChrome

Func IniciarSAT()
	$PACSAT = $PACSAT_dir
	$CerFile = $CerFile_dir
	$KeyFile = $KeyFile_dir
	$PassFIEL = $PassFIEL_data

	Global $sRFC = $sRFC_data
	Global $sPass = $sPass_data

	_WD_Navigate($sSession, $PACSAT)

	While @error <> $_WD_ERROR_Success
		ConsoleWrite("@error: " & @error & @CRLF)
		_WD_Navigate($sSession, $PACSAT)
	WEnd
	_WD_Attach($sSession, "sat.gob.mx", "URL")
	If GUICtrlRead($idRadio_HD) = 1 Then
		MouseDelay("left", 1900, 95, $WaitTime)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		MouseDelay("left", 1340, 90, $WaitTime)
;		MouseDelay("left", 1415, 90, $WaitTime)
	EndIf
;~ 	BtnPress("//button[@id='buttonFiel']")
;~ 	Sleep($WaitTime)
;~ 	BtnPress("//button[@id='btnCertificate']")
;~ 	Pegar($CerFile, $WaitTime)
;~ 	BtnPress("//button[@id='btnPrivateKey']")
;~ 	Pegar($KeyFile, $WaitTime)
;~ 	FillForm("//input[@id='privateKeyPassword']", $PassFIEL)
;~ 	BtnPress("//input[@id='submit']")
	FillForm("//*[@id='rfc']", $sRFC)
	FillForm("//*[@id='password']", $sPass)
	Global $sCaptcha = InputBox("Captcha", "Valor del Captcha", "", "", _
		- 1, -1, 0, 0)
	FillForm("//*[@id='userCaptcha']", $sCaptcha)
	BtnPress("//*[@id='submit']")
EndFunc   ;==>IniciarSAT

Func Iniciar_Fact()
	If $bSAT == False Then
		Init_Webdriver()
		$bSAT = True
;~ 	Else
;~ 		Mostrar()
	EndIf

	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(150)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf

	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(160)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf

	$sTipoFactura = GUICtrlRead($idTipoFactura)
	TipoFact()

	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(140)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf

	$sCliente = GUICtrlRead($idCliente)
	Cliente()

	;Uso Factura
	Sleep(350)
	$sUsoCFDI = GUICtrlRead($idUsoCFDI)
	Switch $sUsoCFDI
		Case 'P01 Por Definir'
			BtnPress('//*[@id="2Receptor_UsoCFDIMoral"]/option[2]')
		Case 'G03 Gastos en General'
			BtnPress('//*[@id="2Receptor_UsoCFDIMoral"]/option[5]')
	EndSwitch

	;Siguiente
	BtnPress("//*[@id='tabReceptorEmisor']/div[3]/div[2]/button[2]")
	Sleep($WaitTime)

	;Agregar formas de pago
;~ 	$sUsoCFDI = GUICtrlRead($idUsoCFDI)
	;03 Transferencia electrónica de fondos (incluye SPEI)
;~ 	BtnPress("//*[@id='FormaPagoLookUp']/option[4]");
	;99 Por Definir
	BtnPress("//*[@id='FormaPagoLookUp']/option[23]")

	;Agregar metodos de pago
	;PPD Pago en Parcialidades o Diferido
	BtnPress("//*[@id='MetodoPagoLookUp']/option[2]")
	;PUE Pago en una sola exhibición
;~ 	BtnPress("//*[@id='MetodoPagoLookUp']/option[3]")

	;Serie
	$sSerie = GUICtrlRead($idSerie)
	FillForm("//*[@id='Serie']", $sSerie)

	;Folio
	$iFolio = GUICtrlRead($idFolio)
	FillForm("//*[@id='Folio']", $iFolio)
;~ 	Sleep($WaitTime)
EndFunc   ;==>Iniciar_Fact

Func Agregar_Art()
;~ 	Mostrar()
	$iClave_SAT = GUICtrlRead($idClaveSAT)
	$sClaveUnidad = GUICtrlRead($idClaveUnidad)
	$iCantidad = GUICtrlRead($idCantidad)

	If $bNFact == True Then
		$bNFact = False
		If GUICtrlRead($idRadio_HD) = 1 Then
			ShowElement(150)
;~ 			ConsoleWrite("HD" & @CRLF)
		EndIf

		If GUICtrlRead($idRadio_SD) = 1 Then
			ShowElement(160)
;~ 			ConsoleWrite("SD" & @CRLF)
		EndIf
	Else
		$bNCon = True
	EndIf

	;Agregar Concepto
	If $bNCon == True Then
		If GUICtrlRead($idRadio_HD) = 1 Then
			ShowElement(-50)
;~ 			ConsoleWrite("HD" & @CRLF)
		EndIf

		If GUICtrlRead($idRadio_SD) = 1 Then
			ShowElement(-80)
;~ 			ConsoleWrite("SD" & @CRLF)
		EndIf
	EndIf
	BtnPress("//*[@id='btnMuestraConcepto']")

	;Clave SAT Producto o Servicio
	BtnPress("//*[@id='ClaveProdServ']")
	FillForm("//*[@id='ClaveProdServ']", $iClave_SAT)

	;Clave SAT Unidad
	BtnPress("//*[@id='ClaveUnidad']")
	FillForm("//*[@id='ClaveUnidad']", $sClaveUnidad)

	;Cantidad
	BtnPress("//*[@id='Cantidad']")
	FillForm("//*[@id='Cantidad']", $iCantidad)

	;Unidad
	$sUnidad = Unidad()
	FillForm("//*[@id='Unidad']", $sUnidad)
	

	;No Identicicación
	$iNumId = GUICtrlRead($idNumId)
	FillForm("//*[@id='NoIdentificacion']", $iNumId)

	;Descripcion
	$sDescripcion = GUICtrlRead($idDescripcion)
	FillForm("//*[@id='Descripcion']", $sDescripcion)

	;Valor Unitario
	$iValorUni = GUICtrlRead($idValorUni)
	FillForm("//*[@id='ValorUnitario']", $iValorUni)

	;Impuestos
	BtnPress("//*[@id='AdicionalImpuestos']")

	;Pestaña Impuestos
	BtnPress("//*[@id='tabsConcepto']/li[2]/a")
	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(-50)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf

	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(-40)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	Sleep($WaitTime)

	;Traslado
	BtnPress("//*[@id='tabImpuestos']/div[1]/div[1]/div/div/div/label[2]/input")

	;Impuesto
	$sImpuesto = GUICtrlRead($idImpuesto)
	Switch $sImpuesto
		Case 'IVA'
			BtnPress("//*[@id='Traslados_Impuesto']/option[3]")
	EndSwitch

	;Tasa
	BtnPress("//*[@id='Traslados_TipoFactor']/option[3]")

	;Valor Tasa
	$iTasa = Tasa()
	FillForm("//*[@id='Traslados_TasaOCuota']", $iTasa)

	;Aceptar Impuesto
	BtnPress("//*[@id='btnAgregaConImpuestoTraslado']")

	;Pestaña Concepto
	BtnPress("//*[@id='tabConceptosPrincipal']")
	Sleep($WaitTime)

	;Aceptar Concepto
	BtnPress("/html/body/main/div[3]/section/form/div[2]/div/div/div[2]/div[3]/div/div[2]/div/div[1]/div/div/div/form/div[3]/div[1]/div[6]/div[2]/div/button[1]")
	Sleep($WaitTime)
EndFunc   ;==>Agregar_Art

Func Sellar_Fact()
	Mostrar()

	;Sellar Factura
	BtnPress("//*[@id='tabComprobante']/div[5]/div[2]/button[3]")

	Sellar()

	$bNFact = True
EndFunc   ;==>Sellar_Fact

Func Complemento()
	If $bSAT == False Then
		Init_Webdriver()
		$bSAT = True
	Else
		Mostrar()
	EndIf

	$sTipoFactura = GUICtrlRead($idTipo_Comp)
	$sCliente = GUICtrlRead($idCliente_Comp)
	$sSerie = GUICtrlRead($idSerie_Comp)
	$iFolio = GUICtrlRead($idFolio_Comp)
	$sUUID = GUICtrlRead($idCFDI)
	$sFechaPago = GUICtrlRead($idFechaPago)
	$sFormaPago = GUICtrlRead($idFormaPago)
	$sMoneda = GUICtrlRead($idMoneda)
;~ 	$idTipo_Cambio
	$iMonto = GUICtrlRead($idMonto)
	$sNumOp = GUICtrlRead($idNumOp)
	$sNomBanOrd = GUICtrlRead($idBanco_Emi)
	$sRfcBanOrd = GUICtrlRead($idRFC_Emi)
	$sCuentaOrd = GUICtrlRead($idCuenta_Ord)
	$sRfcBanBen = GUICtrlRead($idRFC_Ben)
	$sCuentaBen = GUICtrlRead($idCuenta_Ben)
	$sTipo_Cadena = GUICtrlRead($idTipo_Cadena)
	$sCerPago = GUICtrlRead($idCert)
	$sCadenaPago = GUICtrlRead($idCadena)
	$sSelloPago = GUICtrlRead($idSello)
	$iParc = GUICtrlRead($idParcialidad)
	$iImpSaldoAnt = GUICtrlRead($idSaldo_Ant)
	$iImpPagado = GUICtrlRead($idImporte)
	$iImpSaldoIns = GUICtrlRead($idSaldo_Ins)

	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(150)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(160)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf

	TipoFact()
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(140)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	Cliente()

	;Siguiente pagina
	BtnPress("//*[@id='tabReceptorEmisor']/div[3]/div[2]/button[2]")
	Sleep($WaitTime)

	;Serie
	FillForm("//*[@id='Serie']", $sSerie)

	;Folio
	FillForm("//*[@id='Folio']", $iFolio)

	;Seleccionar CFDI rel
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(180)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	BtnPress("//*[@id='EditarCfdiRelacionados']")
	Sleep($WaitTime)

	;Nuevo CFDI rel
	BtnPress("//*[@id='btnAceptarModal']")
	Sleep($WaitTime)

	;UUID rel
	FillForm("//*[@id='UUID']", $sUUID)

	;Agregar CFDI rel
	BtnPress("//div[2]/div/button[1]")
	Sleep($WaitTime)

	;Siguiente pagina
	BtnPress("//*[@id='tabComprobante']/div[5]/div[2]/button[4]")

	;Agregar nuevo recepción de pagos
	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(-80)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(-310)
;		ShowElement(-300)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	BtnPress("/html/body/main/div[3]/section/form/div[2]/div/div/div[3]/div[6]/div/div[2]/div/div[1]/div/div/div/div[3]/div/div/button")
	Sleep($WaitTime)

	;Fecha de pago
	FillForm("//*[@id='FechaPago']", $sFechaPago)

	;Metodo Pago
	Switch $sFormaPago
		Case '01 Efectivo'
			BtnPress('//*[@id="FormaDePagoP"]/option[2]')
		Case '02 Cheque Nominativo'
			BtnPress('//*[@id="FormaDePagoP"]/option[3]')
		Case '03 Transferencia electrónica de fondos (incluye SPEI)'
			BtnPress('//*[@id="FormaDePagoP"]/option[4]')
		Case '04 Tarjeta de crédito'
			BtnPress('//*[@id="FormaDePagoP"]/option[5]')
		Case '28 Tarjeta de débito'
			BtnPress('//*[@id="FormaDePagoP"]/option[19]')
	EndSwitch

	;Moneda
	Switch $sMoneda
		Case 'MXN Peso Mexicano'
			BtnPress('//*[@id="MonedaP"]/option[2]')
		Case 'USD Dolar americano'
			BtnPress('//*[@id="MonedaP"]/option[3]')
	EndSwitch

	;Monto
	FillForm("//*[@id='Monto']", $iMonto)

	;Numero de operacion
	FillForm("//*[@id='NumOperacion']", $sNumOp)

	;RFC banco ordenante
	FillForm("//*[@id='RfcEmisorCtaOrd']", $sRfcBanOrd)

	;Nombre banco ordenante
	FillForm("//*[@id='NomBancoOrdExt']", $sNomBanOrd)

	;Cuenta ordenante
	FillForm("//*[@id='CtaOrdenante']", $sCuentaOrd)

	;RFC banco beneficiario
	FillForm("//*[@id='RfcEmisorCtaBen']", $sRfcBanBen)

	;Cuenta beneficiario
	FillForm("//*[@id='CtaBeneficiario']", $sCuentaBen)

	Switch $sTipo_Cadena
		Case 'N/A'
			BtnPress('//*[@id="TipoCadPago"]/option[1]')
		Case '01 SPEI'
			BtnPress('//*[@id="TipoCadPago"]/option[2]')
	EndSwitch

	;Certificado pago
	FillForm("//*[@id='CertPago']", $sCerPago)

	;Cadena pago
	FillForm("//*[@id='CadPago']", $sCadenaPago)

	;Sello pago
	FillForm("//*[@id='SelloPago']", $sSelloPago)

	;Pestaña documentos relacionados
	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(10)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(40)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	BtnPress("//*[@id='tabsPagos']/li[3]/a")
	Sleep($WaitTime)

	;Boton busqueda UUID
	BtnPress("//*[@id='radioFolio']")
	Sleep($WaitTime)

	;UUID rel
	FillForm("//*[@id='folioFiscal']", $sUUID)
	Sleep($WaitTime * 2)

	;Boton buscar
	BtnPress("//*[@id='Busqueda']/div/div[3]/div/button")
	Sleep($WaitTime)
	$sErrorBusqueda = FindText("//*[@id='tablaRegistros']/h4")
	ConsoleWrite($sErrorBusqueda & @CRLF)

	If $sErrorBusqueda <> "" Then
		BtnPress("//*[@id='Busqueda']/div/div[3]/div/button")
		Sleep($WaitTime)
	EndIf

	;Seleccionar registros encontrados
	BtnPress("//*[@id='tablaRegistros']/div[1]/table/thead/tr/th[1]/input")
	Sleep($WaitTime)

	;Agregar registros seleccionados
	BtnPress("//*[@id='pg_BotonAgregarSeleccionados']")
	Sleep($WaitTime)

	;Editar registro
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(120)
;		ShowElement(100)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	BtnPress("//*[@id='" & $sUUID & "']/td[11]/span[1]")
	Sleep($WaitTime)

	;Parcialidad
	FillForm("//*[@id='NumParcialidad']", $iParc)

	;Importe Saldo Anterior
	FillForm("//*[@id='ImpSaldoAnt']", $iImpSaldoAnt)

	;Importe Pagado
	FillForm("//*[@id='ImpPagado']", $iImpPagado)

	;Importe Saldo Insoluto
	FillForm("//*[@id='ImpSaldoInsoluto']", $iImpSaldoIns)

	;Guardar
	BtnPress("//*[@id='formPagoRelacionadoEditar']/div[4]/div[2]/div/button[1]")
	Sleep($WaitTime)
;~ 	/html/body/main/div[3]/section/form/div[2]/div/div/div[3]/div[6]/div/div[2]/div/div[1]/div/div/div/form/div/div[3]/div/div/div[3]/button
;~ 	//*[@id="botonFinalizar"]

	;Finalizar
	BtnPress("//*[@id='botonFinalizar']")
	Sleep($WaitTime)

	;Pestaña pagos
	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(-880)
;~		ConsoleWrite("HD" & @CRLF)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(-930)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	
	BtnPress("//*[@id='tabsPagos']/li[1]/a")
	Sleep($WaitTime)

	;Aceptar Pago
	If GUICtrlRead($idRadio_HD) = 1 Then
		ShowElement(400)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		ShowElement(400)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf
	BtnPress("/html/body/main/div[3]/section/form/div[2]/div/div/div[3]/div[6]/div/div[2]/div/div[1]/div/div/div/form/div/div[1]/div[8]/div[2]/div/button[1]")
	Sleep($WaitTime)

	;Sellar Comprobante
	BtnPress("//*[@id='tabComplementos']/div[10]/div[2]/button[3]")
	Sleep($WaitTime)

	Sellar()

EndFunc   ;==>Complemento

Func Sellar()
	;Clave FIEL
	FillForm("//*[@id='privateKeyPassword']", $PassFIEL)

	;Clave Privada "KEY"
	;FillForm("//*[@id='privateKeyName']", $KeyFile)
	BtnPress("//*[@id='componenteJS']/div[2]/div[3]/div/label[2]/span")
	Pegar($KeyFile, $WaitTime)
	Sleep($WaitTime)

	;Certificado "CER"
	;FillForm("//*[@id='certificateName']", $CerFile)
	BtnPress("//*[@id='componenteJS']/div[2]/div[4]/div/label[2]/span")
	Pegar($CerFile, $WaitTime)
	Sleep($WaitTime)

	;Confirmar
	BtnPress("//*[@id='btnValidaOSCP']")
	Sleep($WaitTime * 2)

	;Firmar
	BtnPress("//*[@id='btnFirmar']")
	Sleep($WaitTime * 2)

	;Descargar PDF
	BtnPress("/html/body/main/div[3]/section/div[3]/table/tbody/tr/td[1]/a[2]/span")

	;Descargar XML
	BtnPress("/html/body/main/div[3]/section/div[3]/table/tbody/tr/td[1]/a[1]/span")
	Sleep($WaitTime * 2)

	If GUICtrlRead($idRadio_HD) = 1 Then
		MouseDelay("left", 445, 1010, $WaitTime * 2)
		MouseDelay("left", 1900, 1010, $WaitTime)
;~ 		ConsoleWrite("HD" & @CRLF)
	EndIf
	If GUICtrlRead($idRadio_SD) = 1 Then
		MouseDelay("left", 445, 700, $WaitTime * 2)
;		MouseDelay("left", 445, 830, $WaitTime * 2)
		MouseDelay("left", 1350, 700, $WaitTime)
;~ 		ConsoleWrite("SD" & @CRLF)
	EndIf

	_WD_Navigate($sSession, $PACSAT)
EndFunc   ;==>Sellar

Func CSV_Fact()
Global $FileCSV = "E:\Data\Negocio\Cot2022\Fact2022.csv"
Global $aCSV[1]
Global $intCount = 0
Global $intRow = 0
Global $intCol = 0
Global $intLineCount = 0
Global $Set_Fact = 0

_FileReadToArray($FileCSV, $aCSV, Default, ",")
$intLineCount = _FileCountLines($FileCSV) - 1

While $intCount <= $intLineCount
	$intCount = $intCount + 1

	GUICtrlSetData($idFolio, '10001' & $aCSV[$intCount][0])
	GUICtrlSetData($idClaveSAT, $aCSV[$intCount][1])
	GUICtrlSetData($idClaveUnidad, $aCSV[$intCount][2])
	GUICtrlSetData($idCantidad, $aCSV[$intCount][3])
	GUICtrlSetData($idNumId, $aCSV[$intCount][4])
	GUICtrlSetData($idDescripcion, $aCSV[$intCount][5])
	GUICtrlSetData($idValorUni, $aCSV[$intCount][6])
;~ 	GUICtrlSetData($idImpuesto, $aCSV[$intCount][7])
;~ 	GUICtrlSetData($idTasa, $aCSV[$intCount][8])

	If $Set_Fact <> GUICtrlRead($idFolio) Then
		If $bNFact = False Then
			Sellar_Fact()
		EndIf
		Iniciar_Fact()
		Agregar_Art()
		$bNFact = False
	ElseIf $Set_Fact = GUICtrlRead($idFolio) Then
		Agregar_Art()
	EndIf
	$Set_Fact = $iFolio

WEnd
Sellar_Fact()
EndFunc

Func CSV_Comp()
Global $FileCSV = "E:\Data\Negocio\2022\datos_comp.csv"
Global $aCSV[1]
Global $intCount = 0
Global $intRow = 0
Global $intCol = 0
Global $intLineCount = 0

_FileReadToArray($FileCSV, $aCSV, Default, ",")
$intLineCount = _FileCountLines($FileCSV) - 1

While $intCount <= $intLineCount
	$intCount = $intCount + 1

	GUICtrlSetData($idFolio_Comp, '10001' & $aCSV[$intCount][0])
	GUICtrlSetData($idCFDI, $aCSV[$intCount][1])
	GUICtrlSetData($idFechaPago, $aCSV[$intCount][2])
	GUICtrlSetData($idMonto, $aCSV[$intCount][3])
	GUICtrlSetData($idNumOp, $aCSV[$intCount][4])
	GUICtrlSetData($idCuenta_Ord, $aCSV[$intCount][5])
	GUICtrlSetData($idCadena, $aCSV[$intCount][6])
	GUICtrlSetData($idSello, $aCSV[$intCount][7])
	GUICtrlSetData($idSaldo_Ant, $aCSV[$intCount][3])
	GUICtrlSetData($idImporte, $aCSV[$intCount][3])
	Complemento()

WEnd
EndFunc

Func Mostrar()
	WinActivate("[CLASS:Chrome_WidgetWin_1]", "")
	If WinActive("[CLASS:Chrome_WidgetWin_1]", "") == False Then
		WinActivate("[CLASS:Chrome_WidgetWin_1]", "")
	EndIf
	Sleep(250)
EndFunc   ;==>Mostrar

Func TipoFact()
	Switch $sTipoFactura
		Case 'E Egreso'
			BtnPress('//*[@id="Emisor_TipoComprobante"]/option[2]')
		Case 'I Ingreso'
			BtnPress('//*[@id="Emisor_TipoComprobante"]/option[3]')
		Case 'N Nómina'
			BtnPress('//*[@id="Emisor_TipoComprobante"]/option[4]')
		Case 'P Pago'
			BtnPress('//*[@id="Emisor_TipoComprobante"]/option[5]')
		Case 'T Traslado'
			BtnPress('//*[@id="Emisor_TipoComprobante"]/option[6]')
	EndSwitch
EndFunc   ;==>TipoFact

Func Cliente()
	Switch $sCliente
		Case 'Publico en General'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[5]')
		Case 'Misesa'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[6]')
		Case 'Dago'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[7]')
		Case "Nidia Edith"
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[8]')
		Case 'Nazario'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[9]')
		Case 'SE1953'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[10]')
		Case 'Santa Elena'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[11]')
		Case 'Segana'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[12]')
		Case 'Mercato'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[13]')
		Case 'Davila'
			BtnPress('//*[@id="Receptor_RfcCargado"]/option[14]')
	EndSwitch
EndFunc   ;==>Cliente

Func Unidad()
	Switch $sClaveUnidad
		Case "E48 Unidad de servicio" Or "E48"
			Return 'Servicio'
		Case 'H87 Pieza'
			Return 'Pieza'
	EndSwitch
EndFunc   ;==>Unidad

Func Tasa()
	$sTasa = GUICtrlRead($idTasa)
;~ 	ConsoleWrite($sTasa & @CRLF)
	Switch $sTasa
		Case "16%"
;~ 			ConsoleWrite(0.16 & @CRLF)
			Return 0.16
	EndSwitch
EndFunc   ;==>Tasa

Func Catch_Error($btn)
	_WD_WaitElement($sSession, $_WD_LOCATOR_ByXPath, $btn, 100, 100)
	ConsoleWrite("@error: " & @error & @CRLF)
	While (@error = $_WD_ERROR_Timeout) Or (@error = $_WD_ERROR_NoMatch) 
		ConsoleWrite("@error: " & @error & @CRLF)
		_WD_WaitElement($sSession, $_WD_LOCATOR_ByXPath, $btn, 100, 100)
		Sleep(500)
	WEnd
EndFunc   ;==>Catch_Error

Func BtnPress($btn)
	Catch_Error($btn)
	$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $btn)
	_WD_ElementAction($sSession, $sButton, 'click')
	ConsoleWrite($btn & " " & $sButton & @CRLF)
	ConsoleWrite(@CRLF)
EndFunc   ;==>BtnPress

Func FillForm($btn, $value)
	$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $btn)
	_WD_ElementAction($sSession, $sButton, 'value', $value)
	;BtnPress($btn)
	;If _WD_ElementAction($sSession, $sButton,'value') != $value Then
	ConsoleWrite($btn & " " & $sButton & @CRLF)
	ConsoleWrite($value & " " & $sButton & @CRLF)
	ConsoleWrite(@CRLF)
EndFunc   ;==>FillForm

Func FindText($btn)
	Catch_Error($btn)
	$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $btn)
	$sText = _WD_ElementAction($sSession, $sButton, 'text')
	ConsoleWrite($btn & " " & $sButton & @CRLF)
	ConsoleWrite(@CRLF)
	Return $sText
EndFunc   ;==>BtnPress

Func ShowElement($dist)
	Sleep($WaitTime)
	_WD_ExecuteScript($sSession, "return window.scrollBy(0," & $dist & ")")
	ConsoleWrite("Window Scroll by " & $dist & @CRLF)
	ConsoleWrite(@CRLF)
EndFunc   ;==>ShowElement

Func MouseDelay($btn, $pos1, $pos2, $Delay)
	Sleep($Delay)
	MouseClick($btn, $pos1, $pos2, 1, 0)
EndFunc   ;==>MouseDelay

Func Pegar($sText, $Delay)
	ClipPut($sText)
	Sleep($Delay)
	Send("^v")
	Send("{ENTER}")
	Sleep($Delay)
EndFunc   ;==>Pegar
