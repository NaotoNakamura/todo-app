"use client";

import { signIn } from "next-auth/react";

export default function LoginButton() {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginTop: '50px' }}>
      <h1>ログイン</h1>
      
      {/* ボタンをクリックするとGoogleの認証画面へジャンプする */}
      <button 
        onClick={() => signIn("google", { callbackUrl: "/" })}
        style={{
          padding: "10px 20px",
          backgroundColor: "#4285F4",
          color: "white",
          border: "none",
          borderRadius: "5px",
          cursor: "pointer"
        }}
      >
        Googleでログイン
      </button>
    </div>
  );
}
