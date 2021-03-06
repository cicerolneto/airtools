package tl.airtoolsgui.controller;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import tl.airtoolsgui.model.ShellScript;
import tl.airtoolsgui.model.SimpleLogger;

import java.io.File;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.scene.control.TextArea;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.event.Event;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.layout.VBox;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import javafx.stage.Modality;

/**
 * FXML Controller class
 *
 * @author lehmann
 */
public class MainController implements Initializable {

    @FXML
    private BorderPane appPane;
    @FXML
    private CheckBox cbAutoScroll;
    @FXML
    private TextArea textareaLog;
    @FXML
    private Label labelInfo;
    @FXML
    private Label labelStatus;


    @FXML
    private Menu menuFile;
    @FXML
    private MenuItem menuNewProject;
    @FXML
    private MenuItem menuOpenProject;
    @FXML
    private MenuItem menuArchive;
    @FXML
    private MenuItem menuExit;
    @FXML
    private Menu menuEdit;
    @FXML
    private MenuItem menuProjectSettings;
    @FXML
    private MenuItem menuEditImageSet;
    @FXML
    private MenuItem menuEditSiteParam;
    @FXML
    private MenuItem menuEditCameraParam;
    @FXML
    private Menu menuAnalysis;
    @FXML
    private MenuItem menuList;
    @FXML
    private MenuItem menuLightCurve;
    @FXML
    private MenuItem menuMapPhot;
    @FXML
    private Menu menuHelp;
    @FXML
    private MenuItem menuManual;
    @FXML
    private MenuItem menuEnvironment;
    @FXML
    private MenuItem menuDependencies;
    @FXML
    private MenuItem menuAbout;

    @FXML
    private TabPane tabPane;
    @FXML
    private Tab tabImageReduction;
    @FXML
    private Tab tabCometPhotometry;
    @FXML
    private Tab tabMiscTools;

    // Inject controllers (add required @FXML annotation)
    @FXML
    private ImageReductionController paneImageReductionController;
    @FXML
    private CometPhotometryController paneCometPhotometryController;
    @FXML
    private MiscToolsController paneMiscToolsController;

    // additional windows (stages)
    private Stage windowArchive;
    private Stage windowListResults;
    private Stage windowMultiApPhotometry;
    private Stage windowLightCurve;
    
    private Properties projectProperties;
    private String configFile;
    private SimpleLogger logger;
    private ShellScript sh;
    private String progVersion;
    private String progDate;
    private final String onlineManualURL = "https://github.com/ewelot/airtools/blob/master/doc/manual-en.md";
    private final StringProperty projectDir = new SimpleStringProperty();
    private final StringProperty paramDir = new SimpleStringProperty();
    private final StringProperty rawDir = new SimpleStringProperty();
    private final StringProperty tempDir = new SimpleStringProperty();
    private final StringProperty site = new SimpleStringProperty();
    private final IntegerProperty tzoff = new SimpleIntegerProperty();

    
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        System.out.println("MainController: initialize");
        //projectDir.setValue("");
        projectDir.addListener( (v, oldValue, newValue) -> {
            onProjectDirChange();
        });
        
        // "File" menu actions
        menuNewProject.setOnAction((event) -> {
            showNewProjectDialog();
        });
        menuOpenProject.setOnAction((event) -> {
            openExistingProject();
        });
        menuArchive.setOnAction((event) -> {
            showWindowArchive();
        });
        menuExit.setOnAction((event) -> {
            Platform.exit();
        });
        
        // "Edit" menu actions
        menuProjectSettings.setOnAction((event) -> {
            startTextEditor(".airtoolsrc");
        });
        menuEditImageSet.setOnAction((event) -> {
            startTextEditor("set.dat");
        });
        menuEditSiteParam.setOnAction((event) -> {
            startTextEditor("sites.dat");
        });
        menuEditCameraParam.setOnAction((event) -> {
            startTextEditor("camera.dat");
        });
        
        // "Analysis" menu actions
        menuList.setOnAction((event) -> {
            //listResults();
            showWindowListResults();
        });
        menuLightCurve.setOnAction((event) -> {
            showWindowLightCurve();
        });
        menuMapPhot.setOnAction((event) -> {
            showWindowMultiApPhotometry();
        });
        
        // "Help" menu actions
        menuManual.setOnAction((event) -> {
            openOnlineManual();
        });
        menuEnvironment.setOnAction((event) -> {
            paneMiscToolsController.showEnvironment();
        });
        menuDependencies.setOnAction((event) -> {
            checkDependencies();
        });
        menuAbout.setOnAction((event) -> {
            showAboutDialog();
        });

        // Layout
        textareaLog.setStyle("-fx-font-family: monospace");
        labelInfo.setStyle("-fx-background-color: white;"
                + "-fx-text-fill: gray;");
        labelStatus.setStyle("-fx-background-color: white;"
                + "-fx-text-fill: gray;");
        
        /*
        labelInfo.textProperty().bind(
            Bindings.concat(
                textareaLog.scrollTopProperty().asString("%.0f / "),
                textareaLog.heightProperty().asString("%.0f")));
        */

        labelInfo.textProperty().bind(
            Bindings.createStringBinding(() -> {
                String pDir = projectDir.getValue();
                if (pDir != null) {
                    int start=pDir.lastIndexOf("/") + 1;
                    return pDir.substring(start);
                } else {
                    return "";
                }
            }, projectDir));

    }

    public SimpleLogger getLogger() {
        return logger;
    }
    
    public StringProperty getProjectDir () {
        return projectDir;
    }

    
    public void setReferences (String confFileName, ShellScript sh, SimpleLogger logger, String progVersion, String progDate) {
        System.out.println("MainController: setReferences");
        this.configFile = confFileName;
        this.sh = sh;
        this.logger = logger;
        this.progVersion = progVersion;
        this.progDate = progDate;
        
        logger.setLogArea(textareaLog);
        logger.setAutoScroll(cbAutoScroll);
        logger.setStatusLine(labelStatus);
        logger.statusLog("Ready");
        
        /* read initial project settings from config file */
        projectProperties = new Properties();
        loadProperties(configFile);
        rawDir.setValue(projectProperties.getProperty("lastRawDir", "/tmp"));
        tempDir.setValue(projectProperties.getProperty("lastTempDir", "/tmp"));
        paramDir.setValue(projectProperties.getProperty("lastParamDir", "/usr/share/airtools"));
        site.setValue(projectProperties.getProperty("lastSite", ""));
        int i=0;
        String str = projectProperties.getProperty("lastTZOff", "0");
        if (str != null && ! str.isEmpty()) {
            try {
                i=Integer.parseInt(str);
            } catch (NumberFormatException e) {
                logger.log("WARNING: unable to convert lastTZoff in " + confFileName);
            }
        }
        tzoff.setValue(i);
        System.out.println("rawDir=" + rawDir.getValue());

        paneImageReductionController.setReferences(sh, logger);
        paneCometPhotometryController.setReferences(sh, logger);        
        paneCometPhotometryController.projectDir.bind(projectDir);
        paneMiscToolsController.setReferences(sh, logger);        
        paneMiscToolsController.projectDir.bind(projectDir);
        

        String val;
        val = projectProperties.getProperty("lastProjectDir");
        
        if (val == null || val.isEmpty()) {
            val=System.getProperty("user.home");
        } else {
            File inFile = new File(val);
            if (! inFile.exists() || ! inFile.isDirectory()) val=System.getProperty("user.home");
        }
        projectDir.setValue(val);
        sh.setWorkingDir(val);
    }
    
    
    private void onProjectDirChange() {
        System.out.println("onProjectDirChange()");
        logger.log("Project Directory = " + projectDir.getValue());
        sh.setWorkingDir(projectDir.getValue());
        paneImageReductionController.clearTabContent();
        paneCometPhotometryController.clearTabContent();
        paneMiscToolsController.clearTabContent();

        paneCometPhotometryController.updateTabContent();
        if (! paneCometPhotometryController.hasImageSets())
            tabPane.getSelectionModel().selectFirst();

        projectProperties.setProperty("lastProjectDir", projectDir.getValue());
        projectProperties.setProperty("lastParamDir", paramDir.getValue());
        projectProperties.setProperty("lastRawDir", rawDir.getValue());
        projectProperties.setProperty("lastTempDir", tempDir.getValue());
        projectProperties.setProperty("lastSite", site.getValue());
        projectProperties.setProperty("lastTZOff", tzoff.getValue().toString());
        saveProperties(configFile);
    }

    
    private void loadProperties(String fileName) {
        try {
            InputStream inputStream = new FileInputStream(fileName);
            projectProperties.load(inputStream);
            inputStream.close();
        } catch (FileNotFoundException ex) {
            logger.log("WARNING: conf file " + configFile + " not found");
        } catch (IOException ex) {
            logger.log("WARNING: unable to read conf file (IO Error)");
        }
        
    }
    
    
    private void saveProperties(String fileName) {
        try {
            /* TODO: create airtools config directory first */
            OutputStream outputStream = new FileOutputStream(fileName);
            projectProperties.store(outputStream, "global settings");
            outputStream.close();
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    private void startTextEditor(String fileName) {
        File textFile;
        String dir = projectDir.getValue();
        if (fileName != null && ! fileName.isEmpty()) {
            if (dir != null && ! dir.isEmpty()) {
                textFile = new File(dir + "/" + fileName);
            } else {
                textFile=null;
            }
        } else {
            FileChooser fileChooser = new FileChooser();
            if (dir != null && ! dir.isEmpty()) {
                File file = new File(dir);
                if (file != null) fileChooser.setInitialDirectory(file);
            }
            textFile = fileChooser.showOpenDialog(this.appPane.getScene().getWindow());
        }
        if (textFile != null) {
            ProcessBuilder pb = new ProcessBuilder("/bin/bash", "-c", "mousepad " + textFile.getAbsolutePath());
            try {
                pb.start();
            } catch (IOException ex) {
                Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    
    
    private void checkDependencies() {
        //logger.log("WARNING: checkDependencies: not implemented yet.");
        int exitCode;
        
        sh.setEnvVars("");
        sh.setArgs("");
        sh.runFunction("check");
        exitCode=sh.getExitCode();
        logger.log("check finished with " + exitCode);
    }
    
    
    private void openExistingProject() {
        DirectoryChooser dirChooser = new DirectoryChooser();
        File file = null;
        if (! projectDir.getValue().isEmpty())
            file = new File(projectDir.getValue());
        if (file == null || ! file.isDirectory()) {
            file = new File(System.getProperty("user.home"));
        }
        Stage stage = (Stage) appPane.getScene().getWindow();
        dirChooser.setInitialDirectory(file);
        dirChooser.setTitle("Choose existing Project Directory");
        /* note: modal dialog will freeze size of main window
            therefore we pass null (non-modal) instead of stage
        file = dirChooser.showDialog(stage);
        */
        file = dirChooser.showDialog(null);
        if (file != null) {
            // TODO: check for file .airtoolsrc, if missing show a warning message
            projectDir.set(file.getAbsolutePath());
        }
    }
    
    
    private void showOpenProjectDialog() {
        logger.log("# WARNING: use of showOpenProjectDialog is deprecated");
        try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/OpenProject.fxml"));
            Parent parent = fxmlLoader.load();
            OpenProjectController dialogController = fxmlLoader.<OpenProjectController>getController();
            dialogController.setReferences(projectDir);
            
            Scene scene = new Scene(parent);
            Stage stage = new Stage();
            stage.initModality(Modality.APPLICATION_MODAL);
            stage.setScene(scene);
            stage.setTitle("Open AIRTOOLS Project");
            stage.showAndWait();
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    public void showNewProjectDialog() {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/NewProject.fxml"));
            Parent parent = fxmlLoader.load();
            NewProjectController dialogController = fxmlLoader.<NewProjectController>getController();
            dialogController.setReferences(logger, projectDir, paramDir, rawDir, tempDir, site, tzoff);
            
            Scene scene = new Scene(parent);
            Stage stage = new Stage();
            stage.initModality(Modality.APPLICATION_MODAL);
            stage.setScene(scene);
            stage.setTitle("New AIRTOOLS Project");
            stage.showAndWait();
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    public void showWindowArchive() {
        System.out.println("showWindowArchive()");
        if (windowArchive == null) try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/Archive.fxml"));
            Parent parent = fxmlLoader.load();
            ArchiveController controller = fxmlLoader.<ArchiveController>getController();
            controller.setReferences(sh, logger, projectDir);

            Scene scene = new Scene(parent);
            windowArchive = new Stage();
            //windowArchive.initModality(Modality.APPLICATION_MODAL);
            windowArchive.setScene(scene);
            windowArchive.setTitle("Archive Project Data");
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
        windowArchive.showAndWait();
    }
    
    
    public void showWindowListResults() {
        System.out.println("showWindowListResults()");
        if (windowListResults == null) try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/ListResults.fxml"));
            Parent parent = fxmlLoader.load();
            ListResultsController controller = fxmlLoader.<ListResultsController>getController();
            controller.setReferences(sh, logger, projectDir);

            Scene scene = new Scene(parent);
            windowListResults = new Stage();
            //windowListResults.initModality(Modality.APPLICATION_MODAL);
            windowListResults.setScene(scene);
            windowListResults.setTitle("List Results");
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
        windowListResults.showAndWait();
    }
    
    
    public void showWindowMultiApPhotometry() {
        System.out.println("showWindowMultiApPhotometry()");
        if (windowMultiApPhotometry == null) try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/MultiApPhotometry.fxml"));
            Parent parent = fxmlLoader.load();
            MultiApPhotometryController controller = fxmlLoader.<MultiApPhotometryController>getController();
            controller.setReferences(sh, logger, projectDir);

            Scene scene = new Scene(parent);
            windowMultiApPhotometry = new Stage();
            //windowMultiApPhotometry.initModality(Modality.APPLICATION_MODAL);
            windowMultiApPhotometry.setScene(scene);
            windowMultiApPhotometry.setTitle("Multi-Aperture Photometry");
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
        windowMultiApPhotometry.showAndWait();
    }
    
    
    public void showWindowLightCurve() {
        System.out.println("showWindowLightCurve()");
        if (windowLightCurve == null) try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/LightCurve.fxml"));
            Parent parent = fxmlLoader.load();
            LightCurveController controller = fxmlLoader.<LightCurveController>getController();
            controller.setReferences(sh, logger, projectDir);

            Scene scene = new Scene(parent);
            windowLightCurve = new Stage();
            //windowLightCurve.initModality(Modality.APPLICATION_MODAL);
            windowLightCurve.setScene(scene);
            windowLightCurve.setTitle("Plot Light Curve");
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
        windowLightCurve.showAndWait();
    }
    
    
    public void showUnknownDialog() {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/tl/airtoolsgui/view/MultiApPhotometry.fxml"));
            Parent parent = fxmlLoader.load();
            MultiApPhotometryController dialogController = fxmlLoader.<MultiApPhotometryController>getController();
            //multiApPhotometryController.setReferences(logger, projectDir, paramDir, rawDir, tempDir, site, tzoff);
            
            Scene scene = new Scene(parent);
            Stage stage = new Stage();
            stage.initModality(Modality.APPLICATION_MODAL);
            stage.setScene(scene);
            stage.setTitle("Multi-Aperture Photometry");
            stage.showAndWait();
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    private void openOnlineManual() {
        System.out.println("openOnlineManual()");
        //ProcessBuilder pb = new ProcessBuilder("/bin/bash", "-c", "xdg-open " + onlineManualURL);
        ProcessBuilder pb = new ProcessBuilder("xdg-open", onlineManualURL);
        try {
            pb.start();
        } catch (IOException ex) {
            Logger.getLogger(MainController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    private void showAboutDialog() {
        int memtot;
        int memused;
        String author="Thomas Lehmann";
        String mail="t_lehmann@freenet.de";
        Date compileTime = null;
        //DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'");
        DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");

        System.gc();
        memtot = (int) (Runtime.getRuntime().totalMemory()/1024/1024);
        memused = memtot - (int) (Runtime.getRuntime().freeMemory()/1024/1024);
        
        /* determine compilation time (currently not used)
        try {
            String rn = this.getClass().getName().replace('.', '/') + ".class";
            JarURLConnection j = (JarURLConnection) this.getClass().getClassLoader().getResource(rn).openConnection();
            compileTime=new Date(j.getJarFile().getEntry("META-INF/MANIFEST.MF").getTime());
        } catch (IOException e) {
            System.out.println("WARNING: unable to get compilation time");
        }
        */
        
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("About AIRTOOLS");
        alert.setHeaderText("AIRTOOLS " + progVersion);
        /*
            TODO: show version of airtools.sh and airfun.sh
        */
        Label l1 = new Label("GUI version:  " + progVersion);
        //if (compileTime != null) l1.setText(l1.getText() + "  (" + fmt.format(compileTime) + ")");
        l1.setText(l1.getText() + "  (" + progDate + ")");
        Label l2 = new Label("Java-Runtime: " + System.getProperty("java.version"));
        Label l3 = new Label("Operating System: " + System.getProperty("os.name"));
        Label l4 = new Label("Memory: " + memused + "/" + memtot + " MB");
        Label labelAuthor = new Label("Author: " + author);
        Label labelMail = new Label("E-Mail: " + mail);
        /*
        Button buttonMail = new Button("E-Mail");
        buttonMail.setOnAction((event) -> {
            alert.close();
            mainApp.getHostServices().showDocument("mailto:t_lehmann@freenet.de");
        });
        */
        /*
        HBox hboxMail = new HBox();
        hboxMail.setAlignment(Pos.CENTER_LEFT);
        hboxMail.setSpacing(8);
        hboxMail.getChildren().addAll(labelMail, buttonMail);
        hboxMail.getChildren().addAll(labelMail);
        */
        VBox v = new VBox();
        v.setSpacing(2);
        //v.getChildren().addAll(l1, l2, l3, l4, hboxMail,);
        v.getChildren().addAll(l1, l2, l3, l4, labelAuthor, labelMail);
        alert.getDialogPane().contentProperty().set(v);
        // TODO: increase font size relative to system size
        //alert.getDialogPane().setStyle("-fx-font-size: 14px;");
        alert.showAndWait();
    }
    
    
    private void showUnderConstructionDialog() {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Information");
        alert.setHeaderText("Sorry, ...");
        alert.setContentText("this action has not been implemented yet.");
        alert.setResizable(true);
        // TODO: increase size relative to system size
        //alert.getDialogPane().setStyle("-fx-font-size: 14px;");
        //alert.getDialogPane().getScene().getWindow().sizeToScene();
        alert.getDialogPane().setMinHeight(200);
        alert.showAndWait();
    }

    @FXML
    private void onSelectTabImageReduction(Event event) {
        paneImageReductionController.updateTabContent();
    }

    @FXML
    private void onSelectTabCometPhotometry(Event event) {
        paneCometPhotometryController.updateTabContent();
    }

    @FXML
    private void onSelectTabMiscTools(Event event) {
    }
}
