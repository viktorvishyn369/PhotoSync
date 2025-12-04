const { app, BrowserWindow, ipcMain, shell } = require('electron');
const path = require('path');
const os = require('os');

let mainWindow;
let serverProcess;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 600,
    height: 500,
    icon: path.join(__dirname, 'icon.png'),
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true
    },
    resizable: false,
    title: 'PhotoSync Server'
  });

  mainWindow.loadFile('index.html');
}

function startServer() {
  // Use Electron's built-in Node.js instead of spawning external process
  const serverPath = path.join(__dirname, 'server.js');
  
  try {
    // Run server in the same process
    require(serverPath);
    
    if (mainWindow) {
      mainWindow.webContents.send('server-log', 'Server started successfully on port 3000');
    }
    console.log('Server started successfully');
  } catch (error) {
    console.error('Failed to start server:', error);
    if (mainWindow) {
      mainWindow.webContents.send('server-error', `Failed to start server: ${error.message}`);
    }
  }
}

function stopServer() {
  if (serverProcess) {
    serverProcess.kill();
    serverProcess = null;
  }
}

app.whenReady().then(() => {
  createWindow();
  startServer();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  stopServer();
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  stopServer();
});

// IPC handlers
ipcMain.handle('open-uploads-folder', () => {
  const uploadsPath = path.join(__dirname, '..', 'server', 'uploads');
  shell.openPath(uploadsPath);
});

ipcMain.handle('get-server-info', () => {
  const networkInterfaces = os.networkInterfaces();
  let ipAddress = 'localhost';
  
  // Find local IP
  for (const name of Object.keys(networkInterfaces)) {
    for (const net of networkInterfaces[name]) {
      if (net.family === 'IPv4' && !net.internal) {
        ipAddress = net.address;
        break;
      }
    }
  }

  return {
    ip: ipAddress,
    port: 3000,
    url: `http://${ipAddress}:3000`
  };
});

ipcMain.handle('restart-server', () => {
  stopServer();
  setTimeout(() => {
    startServer();
  }, 1000);
});
