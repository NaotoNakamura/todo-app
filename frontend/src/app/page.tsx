import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import LoginButton from "./loginButton";
import Tasks from "./Tasks";

export default async function Home() {
  const session = await getServerSession(authOptions);

  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        {session ? (
          <div className="w-full">
            <h2 className="text-xl font-semibold mb-4">タスク一覧</h2>
            <Tasks />
          </div>
        ) : (
          <div className="flex flex-col items-center gap-6 text-center sm:items-start sm:text-left">
            <LoginButton />
          </div>
        )}
      </main>
    </div>
  );
}
