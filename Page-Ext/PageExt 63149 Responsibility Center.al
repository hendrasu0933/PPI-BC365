pageextension 63149 "Ext Responsibility Center" extends "Responsibility Center Card"
{
    layout
    {
        addafter("Location Code")
        {
            field(Department2; rec.Department2)
            {
                Caption = 'Department';
                ApplicationArea = all;
            }
            field("Responsibility Finance"; rec."Responsibility Finance")
            {
                ApplicationArea = all;
            }
        }
    }
}