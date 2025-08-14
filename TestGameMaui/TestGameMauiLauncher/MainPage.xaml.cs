using TestGameMaui;

namespace TestGameMauiLauncher
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void LaunchGameButton_Clicked(object sender, EventArgs e)
        {
            TestGameCrossPlatformHelper.LaunchGame();
        }
    }

}
