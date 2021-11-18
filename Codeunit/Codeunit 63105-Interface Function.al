codeunit 63105 "Interface Function"
{
    trigger OnRun()
    begin

    end;

    procedure CreateSalesInv(var SalesPPI: Record "Sales PPI")
    var
        SalesInv: Record "Sales Header";
        PostSalesInv: Record "Sales Invoice Header";
    begin
        if SalesPPI.FindSet() then
            repeat
                if not SalesPPI.Processed then begin
                    if PostSalesInv.get(SalesPPI."Document No.") then
                        Error('Dokumen ini sudah terposting');
                    if not SalesInv.Get(SalesInv."Document Type"::Invoice, SalesPPI."Document No.") then
                        CreateHeader(SalesPPI);
                    SalesPPI.Processed := true;
                    SalesPPI.Modify();
                    CreateLine(SalesPPI);
                end;
            until SalesPPI.Next() = 0;
    end;

    local procedure CreateHeader(var SalesPPI: Record "Sales PPI")
    var
        SalesInv: Record "Sales Header";
    begin
        SalesInv."Document Type" := SalesInv."Document Type"::Invoice;
        SalesInv."No." := SalesPPI."Document No.";
        SalesInv.Insert(true);
        SalesInv.Validate("Sell-to Customer No.", SalesPPI."Cust. No. BC");
        if SalesPPI.Currency <> SalesInv."Currency Code" then
            SalesInv.Validate("Currency Code", SalesPPI.Currency);
        SalesInv.Validate("Shortcut Dimension 1 Code", SalesPPI."Unit Bisnis");
        SalesInv.Validate("Posting Date", SalesPPI."Posting Date");
        SalesInv.Modify();

    end;

    local procedure CreateLine(var SalesPPI: Record "Sales PPI")
    var
        SalesInvLine: Record "Sales Line";
        LineNo: Integer;
    begin
        SalesInvLine.SetRange("Document Type", SalesInvLine."Document Type"::Invoice);
        SalesInvLine.SetRange("Document No.", SalesPPI."Document No.");
        if SalesInvLine.FindLast() then
            LineNo := SalesInvLine."Line No." + 10000
        else
            LineNo := 10000;
        SalesInvLine.Init();
        SalesInvLine."Document Type" := SalesInvLine."Document Type"::Invoice;
        SalesInvLine."Document No." := SalesPPI."Document No.";
        SalesInvLine."Line No." := LineNo;
        SalesInvLine.Validate(Type, SalesInvLine.Type::Item);
        SalesInvLine.Validate("No.", SalesPPI."Item No. BC");
        SalesInvLine.Validate(Quantity, SalesPPI.Quantity);
        SalesInvLine.Validate("Unit of Measure Code", SalesPPI."Unit of Measure");
        SalesInvLine.Validate("Unit Price", SalesPPI."Unit Price");
        SalesInvLine.Insert();
    end;

    procedure CreateCustomer(var CustFrontEnd: Record "Customer Front End")
    var
        Customer: Record Customer;
        ConfigTemplateHeader: Record "Config. Template Header";
        DimensionsTemplate: Record "Dimensions Template";
        CustomerRecRef: RecordRef;
        ConfigTemplateManagement: Codeunit "Config. Template Management";

    begin
        if CustFrontEnd."Customer No. BC" <> '' then
            exit;
        if CustFrontEnd.NPWP <> '' then
            CheckNPWP(CustFrontEnd.NPWP, CustFrontEnd.Kode, CustFrontEnd."Unit Bisnis");
        Customer.Init();
        Customer."No." := CustFrontEnd.Kode;
        Customer.Name := CustFrontEnd.Nama;
        Customer.Address := CustFrontEnd.Alamat;
        Customer."E-Mail" := CustFrontEnd.Email;
        Customer."Fax No." := CustFrontEnd.Fax;
        Customer.City := CustFrontEnd.Kota;
        Customer."VAT Registration No." := CustFrontEnd.NPWP;
        Customer."Phone No." := CustFrontEnd."Telp 1";
        Customer."Mobile Phone No." := CustFrontEnd."Telp 2";
        Customer.Contact := CustFrontEnd."Kontak Person";
        Customer."No. Series" := CustFrontEnd."Unit Bisnis";
        Customer.Insert();
        Customer.Validate("Global Dimension 1 Code", CustFrontEnd."Unit Bisnis");
        Customer.Modify();
        ConfigTemplateHeader.Get(CustFrontEnd."Config Template BC");
        CustomerRecRef.GETTABLE(Customer);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, CustomerRecRef);
        DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
        CustFrontEnd."Customer No. BC" := Customer."No.";
        CustFrontEnd.Modify();
    end;

    local procedure CheckNPWP(VATRegNo: Text[20]; Number: Code[20]; UnitBisnis: Code[20])
    var
        Check: Boolean;
        Finish: Boolean;
        TextString: Text;
        CustomerIdentification: Text;
        Cust: Record Customer;
        Text002: Label 'No NPWP ini sudah teregister atas customer berikut:\ %1. \Apakah Anda ingin tetap melanjutkan membuat master data customer ini?';
    begin
        Check := TRUE;
        TextString := '';
        Cust.SETCURRENTKEY("VAT Registration No.");
        Cust.SETRANGE("VAT Registration No.", VATRegNo);
        Cust.SetRange("Global Dimension 1 Code", UnitBisnis);
        Cust.SETFILTER("No.", '<>%1', Number);
        IF Cust.FINDSET THEN BEGIN
            Check := FALSE;
            Finish := FALSE;
            REPEAT
                CustomerIdentification := Cust."No.";
                AppendString(TextString, Finish, CustomerIdentification);
            UNTIL (Cust.NEXT = 0) OR Finish;
        END;
        IF NOT Check THEN
            if not Confirm(STRSUBSTNO(Text002, TextString)) then
                Error('');
    end;

    LOCAL procedure AppendString(VAR String: Text; VAR Finish: Boolean; AppendText: Text)
    begin
        CASE TRUE OF
            Finish:
                EXIT;
            String = '':
                String := AppendText;
            STRLEN(String) + STRLEN(AppendText) + 5 <= 250:
                String += ', ' + AppendText;
            ELSE BEGIN
                    String += '...';
                    Finish := TRUE;
                END;
        END;
    end;

    procedure CreateItem(var ItemFrontEnd: Record "Item Front End")
    var
        Item: Record Item;
        ConfigTemplateHeader: Record "Config. Template Header";
        DimensionsTemplate: Record "Dimensions Template";
        ItemRecRef: RecordRef;
        ConfigTemplateManagement: Codeunit "Config. Template Management";

    begin
        if ItemFrontEnd."Item No. BC" <> '' then
            exit;
        Item.Init();
        Item."No." := ItemFrontEnd.Kode;
        Item.Description := ItemFrontEnd.Deskripsi;
        Item.validate("Base Unit of Measure", ItemFrontEnd."Unit of Measure");
        Item.Insert();
        ConfigTemplateHeader.Get(ItemFrontEnd."Config Template BC");
        ItemRecRef.GETTABLE(Item);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
        DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Item."No.", DATABASE::Item);
        ItemFrontEnd."Item No. BC" := Item."No.";
        ItemFrontEnd.Modify();
    end;

    var
        myInt: Integer;
}