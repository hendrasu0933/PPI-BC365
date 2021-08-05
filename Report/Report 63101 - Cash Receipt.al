report 63101 "Cash Receipt"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report 63101 - Cash Receipt.rdlc';
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
            column(Bal__Account_No_; "Bal. Account No.") { }
            column(Account_No_; "Account No.") { }
            column(Journal_Template_Name; "Journal Template Name") { }
            column(Document_No_; "Document No.") { }
            column(Description; Description) { }
            column(VAT_Amount; "VAT Amount") { }
            column(d_totalAmount; d_totalAmount) { }
            column(Amount__LCY_; "Amount (LCY)") { }
            column(t_NameCustomer; t_NameCustomer) { }
            column(t_Approve; t_Approve) { }
            column(t_R_Finance; t_R_Finance) { }
            column(t_Department; t_Department) { }
            column(Comment; Comment) { }
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

                rec_JournalLine2: Record "Gen. Journal Line";
                rec_Customer2: Record Customer;
                rec_Vendor2: Record Vendor;
                rec_GlAccount2: Record "G/L Account";
                rec_BankAccount2: Record "Bank Account";
                rec_FixedAsset2: Record "Fixed Asset";
                rec_Employee2: Record Employee;
                rec_ApprovelEntry2: Record "Approval Entry";
            begin
                d_totalAmount := "Gen. Journal Line"."Amount (LCY)";
                TotalCost := d_totalAmount;
                Nilai := Round(TotalCost, 0.01, '=');

                AmountVendor := Nilai;

                RepCheck.FormatNoText(NoText, AmountVendor, 'USD');

                AmountInWords := DelStr(NoText[1], 1, 5);
                if "Bal. Account Type" = "Bal. Account Type"::Customer then begin
                    rec_Customer.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if rec_Customer.FindFirst() then
                        t_NameCustomer := rec_Customer.Name;
                end;

                if "Bal. Account Type" = "Bal. Account Type"::"G/L Account" then begin
                    rec_GlAccount.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if rec_GlAccount.FindFirst() then
                        t_NameCustomer := rec_GlAccount.Name;
                end;

                if "Bal. Account Type" = "Bal. Account Type"::"G/L Account" then begin
                    rec_Vendor.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if rec_Vendor.FindFirst() then
                        t_NameCustomer := rec_Vendor.Name;
                end;

                if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
                    rec_BankAccount.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if rec_BankAccount.FindFirst() then
                        t_NameCustomer := rec_BankAccount.Name;
                end;

                if "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" then begin
                    rec_FixedAsset.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if rec_FixedAsset.FindFirst() then
                        t_NameCustomer := rec_FixedAsset.Description;
                end;

                if "Bal. Account Type" = "Bal. Account Type"::Employee then begin
                    rec_Employee.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if rec_Employee.FindFirst() then
                        t_NameCustomer := rec_Employee.FullName();
                end;

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
    var
        rec_ResponsibilityCenter: Record "Responsibility Center";
    begin
        CompanyInformasi.get;
        CompanyInformasi.CalcFields(Picture);
        // GET RESPONSIBILITY CENTER
        rec_ResponsibilityCenter.SetRange(Code, 'PPU');
        if rec_ResponsibilityCenter.FindFirst() then begin
            t_Department := rec_ResponsibilityCenter.Department2;
            t_R_Finance := rec_ResponsibilityCenter."Responsibility Finance";
        end else begin
            t_Department := 'An.Direksi';
            t_R_Finance := 'Finance Manager';
        end;
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
        // responsibility center
        t_Department: Text;
        t_R_Finance: Text;
}