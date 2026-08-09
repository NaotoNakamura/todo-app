import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";

type Task = {
  id: number;
  title: string;
  is_completed: boolean;
  started_at: string | null;
  finished_at: string | null;
};

export default async function Tasks() {
  const session = await getServerSession(authOptions);
  const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/tasks`, {
    headers: { Authorization: `Bearer ${session!.accessToken}` },
    cache: "no-store",
  });
  const tasks: Task[] = res.ok ? await res.json() : [];

  if (tasks.length === 0) {
    return <p className="text-gray-500">タスクがありません</p>;
  }

  return (
    <ul className="w-full divide-y divide-gray-200">
      {tasks.map((task) => (
        <li key={task.id} className="flex items-center justify-between py-3">
          <span className="text-gray-900 dark:text-gray-100">{task.title}</span>
          <span
            className={`text-sm px-2 py-0.5 rounded-full ${
              task.is_completed
                ? "bg-green-100 text-green-700"
                : "bg-yellow-100 text-yellow-700"
            }`}
          >
            {task.is_completed ? "完了" : "未完了"}
          </span>
        </li>
      ))}
    </ul>
  );
}
