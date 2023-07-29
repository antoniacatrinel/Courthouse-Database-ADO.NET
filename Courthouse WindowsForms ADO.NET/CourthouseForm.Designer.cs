namespace CourthouseWindowsForms
{
    partial class CourthouseForm
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            parentGridView = new DataGridView();
            childGridView = new DataGridView();
            parentLabel = new Label();
            childLabel = new Label();
            addButton = new Button();
            removeButton = new Button();
            updateButton = new Button();
            childPanel = new Panel();
            ((System.ComponentModel.ISupportInitialize)parentGridView).BeginInit();
            ((System.ComponentModel.ISupportInitialize)childGridView).BeginInit();
            SuspendLayout();
            // 
            // parentGridView
            // 
            parentGridView.AllowUserToAddRows = false;
            parentGridView.AllowUserToDeleteRows = false;
            parentGridView.AllowUserToOrderColumns = true;
            parentGridView.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            parentGridView.EditMode = DataGridViewEditMode.EditProgrammatically;
            parentGridView.Location = new Point(60, 67);
            parentGridView.MultiSelect = false;
            parentGridView.Name = "parentGridView";
            parentGridView.ReadOnly = true;
            parentGridView.RowHeadersWidth = 62;
            parentGridView.RowTemplate.Height = 33;
            parentGridView.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            parentGridView.Size = new Size(783, 428);
            parentGridView.TabIndex = 0;
            parentGridView.SelectionChanged += ParentGridView_SelectionChanged;
            // 
            // childGridView
            // 
            childGridView.AllowUserToAddRows = false;
            childGridView.AllowUserToDeleteRows = false;
            childGridView.AllowUserToOrderColumns = true;
            childGridView.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            childGridView.EditMode = DataGridViewEditMode.EditProgrammatically;
            childGridView.Location = new Point(60, 559);
            childGridView.MultiSelect = false;
            childGridView.Name = "childGridView";
            childGridView.RowHeadersWidth = 62;
            childGridView.RowTemplate.Height = 33;
            childGridView.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            childGridView.Size = new Size(783, 428);
            childGridView.TabIndex = 1;
            childGridView.SelectionChanged += ChildGridView_SelectionChanged;
            // 
            // parentLabel
            // 
            parentLabel.AutoSize = true;
            parentLabel.Location = new Point(60, 19);
            parentLabel.Name = "parentLabel";
            parentLabel.Size = new Size(106, 25);
            parentLabel.TabIndex = 2;
            parentLabel.Text = "Parent Table";
            // 
            // childLabel
            // 
            childLabel.AutoSize = true;
            childLabel.Location = new Point(60, 515);
            childLabel.Name = "childLabel";
            childLabel.Size = new Size(97, 25);
            childLabel.TabIndex = 3;
            childLabel.Text = "Child Table";
            // 
            // addButton
            // 
            addButton.Location = new Point(1219, 559);
            addButton.Name = "addButton";
            addButton.Size = new Size(112, 34);
            addButton.TabIndex = 4;
            addButton.Text = "add";
            addButton.UseVisualStyleBackColor = true;
            addButton.Click += AddButton_Click;
            // 
            // removeButton
            // 
            removeButton.Location = new Point(1219, 622);
            removeButton.Name = "removeButton";
            removeButton.Size = new Size(112, 34);
            removeButton.TabIndex = 5;
            removeButton.Text = "remove";
            removeButton.UseVisualStyleBackColor = true;
            removeButton.Click += RemoveButton_Click;
            // 
            // updateButton
            // 
            updateButton.Location = new Point(1219, 679);
            updateButton.Name = "updateButton";
            updateButton.Size = new Size(112, 34);
            updateButton.TabIndex = 6;
            updateButton.Text = "update";
            updateButton.UseVisualStyleBackColor = true;
            updateButton.Click += UpdateButton_Click;
            // 
            // childPanel
            // 
            childPanel.Location = new Point(874, 559);
            childPanel.Name = "childPanel";
            childPanel.Size = new Size(315, 428);
            childPanel.TabIndex = 7;
            // 
            // CourthouseForm
            // 
            ClientSize = new Size(1379, 1014);
            Controls.Add(childPanel);
            Controls.Add(updateButton);
            Controls.Add(removeButton);
            Controls.Add(addButton);
            Controls.Add(childLabel);
            Controls.Add(parentLabel);
            Controls.Add(childGridView);
            Controls.Add(parentGridView);
            Name = "CourthouseForm";
            Text = "Courthouse";
            FormClosing += CourthouseForm_FormClosing;
            Load += CourthouseForm_Load;
            ((System.ComponentModel.ISupportInitialize)parentGridView).EndInit();
            ((System.ComponentModel.ISupportInitialize)childGridView).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private DataGridView parentGridView;
        private DataGridView childGridView;
        private Label parentLabel;
        private Label childLabel;
        private Button addButton;
        private Button removeButton;
        private Button updateButton;
        private Panel childPanel;
    }
}