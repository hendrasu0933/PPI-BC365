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
        if PostSalesInv.get(SalesPPI."Document No.") then
            Error('Dokumen ini sudah terposting');
        if not SalesInv.Get(SalesInv."Document Type"::Invoice, SalesPPI."Document No.") then
            CreateHeader(SalesPPI);
        CreateLine(SalesPPI);
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
        Customer.Insert();
        ConfigTemplateHeader.Get(CustFrontEnd."Config Template BC");
        CustomerRecRef.GETTABLE(Customer);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, CustomerRecRef);
        DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
        CustFrontEnd."Customer No. BC" := Customer."No.";
        CustFrontEnd.Modify();
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