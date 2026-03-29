namespace POD.Logic.Reporting
{
    public interface IReportViewer
    {
        void Render(IReportParametersContainer container);

        void Initialize();
    }
}