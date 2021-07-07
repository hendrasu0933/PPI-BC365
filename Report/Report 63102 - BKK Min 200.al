report 63102 "BKK Min 200"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63102 - BKK Min 200.rdlc';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(Line_No_; "Line No.") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Journal_Template_Name; "Journal Template Name") { }
            column(CompanyInformasi; CompanyInformasi.City) { }
            column(Posting_Date; "Posting Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Amount; Amount) { }
            column(Amount__LCY_; "Amount (LCY)") { }
            column(t_AddressCustomer; t_AddressCustomer) { }
            column(t_NameCustomer; t_NameCustomer) { }
            column(AmountInWords; text.UpperCase(AmountInWords)) { }
            column(Description; Description) { }
            trigger OnAfterGetRecord()
            var
                rec_Customer: Record Customer;
                rec_Vendor: Record Vendor;
            begin
                rec_Customer.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Customer.FindFirst() then begin
                    t_NameCustomer := rec_Customer.Name;
                    t_AddressCustomer := rec_Customer.Address + rec_Customer."Address 2";
                end;
                rec_Vendor.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Vendor.FindFirst() then begin
                    t_NameCustomer := rec_Vendor.Name;
                    t_AddressCustomer := rec_Vendor.Address + rec_Vendor."Address 2";
                end;

                RepCheck.FormatNoText(arrray, "Gen. Journal Line"."Amount (LCY)", '');
                AmountInWords := arrray[1] + 'Rupiah';
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInformasi.get;
        CompanyInformasi.CalcFields(Picture)
    end;

    var
        // g1
        CompanyInformasi: record "Company Information";
        //g2
        t_NameCustomer: Text;
        t_AddressCustomer: Text;
        // g3
        RepCheck: Codeunit "Saying Indonesia";
        AmountInWords: Text;
        arrray: array[1] of text;
        AmountVendor: Decimal;
        TotalCost: decimal;
        Nilai: Decimal;
        d_totalAmount: Decimal;
        NoText: array[2] of Text;
}