using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace CourthouseWindowsForms
{
    public partial class CourthouseForm : Form
    {
        private const string FOREIGN_KEY_CONSTRAINT_NAME = "FK_parent_child";

        private SqlConnection? _databaseConnection;
        private SqlDataAdapter? _parentDataAdapter, _childDataAdapter;
        private DataRelation? _parentChildDataRelation;
        private BindingSource? _parentBindingSource, _childBindingSource;
        private readonly DataSet _tableData = new();

        private static readonly string connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString.ToString();
        private static readonly string parentTableName = ConfigurationManager.AppSettings["ParentTableName"]!;
        private static readonly string childTableName = ConfigurationManager.AppSettings["ChildTableName"]!;
        private static readonly string parentID = ConfigurationManager.AppSettings["ParentID"]!;
        private static readonly string childID = ConfigurationManager.AppSettings["ChildID"]!;
        private readonly List<string> childColumnsList = new(ConfigurationManager.AppSettings["ChildColumns"]!.Split(','));
        private static readonly string selectParent = ConfigurationManager.AppSettings["SelectParent"]!;
        private static readonly string selectChild = ConfigurationManager.AppSettings["SelectChild"]!;
        private static readonly string selectChildren = ConfigurationManager.AppSettings["SelectChildren"]!;
        private static readonly string addChild = ConfigurationManager.AppSettings["AddChild"]!;
        private static readonly string removeChild = ConfigurationManager.AppSettings["RemoveChild"]!;
        private static readonly string updateChild = ConfigurationManager.AppSettings["UpdateChild"]!;

        public CourthouseForm()
        {
            InitializeComponent();
        }

        private void CourthouseForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            _databaseConnection!.Close();
        }


        private void CourthouseForm_Load(object sender, EventArgs e)
        {
            _databaseConnection = new SqlConnection(connectionString);
            _databaseConnection.Open();

            // parent
            _parentDataAdapter = new SqlDataAdapter(selectParent, _databaseConnection);
            _parentDataAdapter.Fill(_tableData, parentTableName);

            // child
            _childDataAdapter = new SqlDataAdapter(selectChildren, _databaseConnection);
            _childDataAdapter.Fill(_tableData, childTableName);

            DataColumn? referenceId = _tableData.Tables[parentTableName]!.Columns[parentID]!;
            DataColumn? foreignId = _tableData.Tables[childTableName]!.Columns[parentID]!;
            _parentChildDataRelation = new DataRelation(FOREIGN_KEY_CONSTRAINT_NAME, referenceId!, foreignId!);
            _tableData.Relations.Add(_parentChildDataRelation);

            _parentBindingSource = new BindingSource
            {
                DataSource = _tableData,
                DataMember = parentTableName
            };

            _childBindingSource = new BindingSource
            {
                DataSource = _parentBindingSource,
                DataMember = FOREIGN_KEY_CONSTRAINT_NAME
            };

            parentGridView.DataSource = _parentBindingSource;
            childGridView.DataSource = _childBindingSource;

            PopulateChildPanel(sender, e);
        }

        private void PopulateChildPanel(object sender, EventArgs e)
        {
            int coordinateY = 0;
            childPanel.Controls.Clear();

            foreach (string column in childColumnsList)
            {
                Label label = new Label
                {
                    Text = column,
                    AutoSize = true,
                    Location = new Point(0, coordinateY)
                };

                TextBox text = new TextBox
                {
                    Name = column,
                    Width = childPanel.Width - label.Width,
                    Location = new Point(90, coordinateY)
                };

                childPanel.Controls.Add(label);
                childPanel.Controls.Add(text);
                childPanel.Show();

                coordinateY += 50;
            }

            Label foreignKeyLabel = new Label
            {
                Text = parentID,
                AutoSize = true,
                Location = new Point(0, coordinateY)
            };

            TextBox foreignKeyTextBox = new TextBox
            {
                Name = parentID,
                Width = childPanel.Width - foreignKeyLabel.Width,
                Location = new Point(90, coordinateY)
            };

            childPanel.Controls.Add(foreignKeyLabel);
            childPanel.Controls.Add(foreignKeyTextBox);
            childPanel.Show();
        }

        private void ReloadChildTableView()
        {
            _tableData!.Tables[childTableName]!.Clear();
            _childDataAdapter!.Fill(_tableData, childTableName);
        }

        private void ParentGridView_SelectionChanged(object sender, EventArgs e)
        {
            if (parentGridView.SelectedRows.Count == 0)
            {
                return;
            }

            DataGridViewRow? selectedRow = parentGridView.SelectedRows[0];

            _childDataAdapter!.SelectCommand = new SqlCommand(selectChild, _databaseConnection)
            {
                Parameters = { new SqlParameter("@" + parentID, selectedRow.Cells[0].Value) }
            };

            ReloadChildTableView();
        }

        private void ChildGridView_SelectionChanged(object sender, EventArgs e)
        {
            if (childGridView.SelectedRows.Count == 0)
                return;

            DataGridViewRow selectedRow = childGridView.SelectedRows[0];

            foreach (DataGridViewCell cell in selectedRow.Cells)
            {
                // Get the name of the column
                string columnName = childGridView.Columns[cell.ColumnIndex].Name;

                // Get the textbox with the same name as the column
                TextBox textBox = (TextBox)childPanel.Controls[columnName]!;

                if (textBox == null)
                {
                    continue;
                }

                // Set the text of the textbox to the value of the cell
                textBox.Text = cell.Value.ToString();
            }

        }


        private void AddButton_Click(object sender, EventArgs e)
        {
            SqlCommand addCommand = new SqlCommand(addChild, _databaseConnection);
            addCommand.Parameters.AddWithValue("@" + parentID, parentGridView.CurrentRow.Cells[0].Value);

            foreach (string column in childColumnsList)
            {
                TextBox textBox = (TextBox)childPanel.Controls[column]!;
                addCommand.Parameters.AddWithValue("@" + column, textBox.Text);
            }

            try
            {
                addCommand.ExecuteNonQuery();
                MessageBox.Show("Record added successfully!");
                ReloadChildTableView();
            }
            catch (SqlException exception)
            {
                string errorMessage = exception.Number switch
                {
                    2627 => "There is column data that should be unique in the table!",
                    547 => "There's no parent with the given id!",
                    _ => exception.Message,
                };
                MessageBox.Show(errorMessage);
            }

        }

        private void RemoveButton_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Are you sure you want to remove that record?", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                SqlCommand removeCommand = new SqlCommand(removeChild, _databaseConnection);
                removeCommand.Parameters.AddWithValue("@" + childID, childGridView.CurrentRow.Cells[0].Value);

                removeCommand.ExecuteNonQuery();
                MessageBox.Show("Record removed successfully!");
                ReloadChildTableView();
            }
        }

        private void UpdateButton_Click(object sender, EventArgs e)
        {
            SqlCommand updateCommand = new SqlCommand(updateChild, _databaseConnection);

            updateCommand.Parameters.AddWithValue("@" + childID, childGridView.CurrentRow.Cells[0].Value);

            TextBox text = (TextBox)childPanel.Controls[parentID]!;
            if (text.Text == "")
            {
                updateCommand.Parameters.AddWithValue("@" + parentID, parentGridView.CurrentRow.Cells[0].Value);
            }
            else
            {
                updateCommand.Parameters.AddWithValue("@" + parentID, text.Text);
            }

            foreach (string column in childColumnsList)
            {
                TextBox textBox = (TextBox)childPanel.Controls[column]!;
                updateCommand.Parameters.AddWithValue("@" + column, textBox.Text);
            }

            try
            {
                updateCommand.ExecuteNonQuery();
                MessageBox.Show("Record updated successfully!");
                ReloadChildTableView();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
