importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCPGQQBM0OXEYC8XLOMzrNHyct00Pvs-PA',
  appId: '1:325136993258:web:429ca200628b98ad7a8093',
  messagingSenderId: '325136993258',
  projectId: 'entaobora',
  authDomain: 'entaobora.firebaseapp.com',
  storageBucket: 'entaobora.firebasestorage.app',
  measurementId: 'G-NM2W64K39H',
});

firebase.messaging();
