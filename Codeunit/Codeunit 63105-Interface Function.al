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
        if not SalesInv.Get(SalesInv."Document Type", SalesPPI."Document No.") then
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
        SalesInv.Validate("Sell-to Customer No.", SalesPPI."Customer No.");
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

    var
        myInt: Integer;
}