"use client";

import { useSession } from "next-auth/react";
import LoginButton from "./loginButton";

export default function Home() {
  const { data: session, status } = useSession();

  if (status === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-zinc-50 dark:bg-black">
        <p className="text-gray-500">読み込み中...</p>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        {session ? (
          <h2>タスク一覧</h2>
        ) : (
          <div className="flex flex-col items-center gap-6 text-center sm:items-start sm:text-left">
            <LoginButton />
          </div>
        )}
      </main>
    </div>
  );
}
