report 63105 "Realisasi Penda & Biaya Pusat"
{
    Caption = 'Realisasi Anggaran Pendapatan dan Biaya Per Pusat';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63105 - Realisasi Penda & Biaya Pusat.rdlc';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Line_No_; "Line No.") { }
            column(CompanyInformasi; CompanyInformasi.City) { }
            column(CompanyInformasiName; CompanyInformasi.Name) { }
            column(Posting_Date; "Posting Date") { }
            column(Account_No_; "Account No.") { }
            column(Journal_Template_Name; "Journal Template Name") { }
            column(Document_No_; "Document No.") { }
            column(Description; Description) { }
            column(VAT_Amount; "VAT Amount") { }
            column(d_totalAmount; d_totalAmount) { }
            column(Amount__LCY_; "Amount (LCY)") { }
            column(t_NameCustomer; t_NameCustomer) { }
            column(t_Approve; t_Approve) { }
            column(AmountInWords; text.UpperCase(AmountInWords)) { }
            trigger OnAfterGetRecord()
            var
                rec_JournalLine: Record "Gen. Journal Line";
                rec_Customer: Record Customer;
                rec_Vendor: Record Vendor;
                rec_GlAccount: Record "G/L Account";
                rec_BankAccount: Record "Bank Account";
                rec_FixedAsset: Record "Fixed Asset";
                rec_Employee: Record Employee;
                rec_ApprovelEntry: Record "Approval Entry";
            begin
                // amount in words
                // d_totalAmount := 0;
                // rec_JournalLine.SetRange("Journal Template Name", 'CASHRCPT');
                // rec_JournalLine.SetRange("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                // if rec_JournalLine.FindFirst() then
                //     repeat
                d_totalAmount := "Gen. Journal Line"."Amount (LCY)";
                TotalCost := d_totalAmount;
                Nilai := Round(TotalCost, 0.01, '=');

                AmountVendor := Nilai;

                RepCheck.FormatNoText(NoText, AmountVendor, 'USD');

                AmountInWords := DelStr(NoText[1], 1, 5);
                // until rec_JournalLine.Next = 0;
                // get data vendor
                rec_Customer.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Customer.FindFirst() then
                    t_NameCustomer := rec_Customer.Name;
                rec_GlAccount.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_GlAccount.FindFirst() then
                    t_NameCustomer := rec_GlAccount.Name;
                rec_Vendor.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Vendor.FindFirst() then
                    t_NameCustomer := rec_Vendor.Name;
                rec_BankAccount.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_BankAccount.FindFirst() then
                    t_NameCustomer := rec_BankAccount.Name;
                rec_FixedAsset.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_FixedAsset.FindFirst() then
                    t_NameCustomer := rec_FixedAsset.Description;
                rec_Employee.SetRange("No.", "Gen. Journal Line"."Account No.");
                if rec_Employee.FindFirst() then
                    t_NameCustomer := rec_Employee.FullName();

                // approvel Data
                rec_ApprovelEntry.SetRange("Document No.", "Gen. Journal Line"."Document No.");
                if rec_ApprovelEntry.FindFirst() then
                    t_Approve := 'APPROVED';
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
        CompanyInformasi: record "Company Information";
        RepCheck: Codeunit "Saying Eng";
        NoText: array[2] of Text;
        AmountInWords: Text;
        AmountVendor: Decimal;
        TotalCost: decimal;
        Nilai: Decimal;
        d_totalAmount: Decimal;
        t_NameCustomer: Text;
        t_Approve: Text;
}