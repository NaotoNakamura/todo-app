import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";

const handler = NextAuth({
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
  ],
  callbacks: {
    // Googleログインが成功した後に実行される
    async signIn({ account, user }: any) {
      if (account?.provider === "google") {
        try {
          // Rails APIへ fetch でリクエスト
          const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/auth/google`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ id_token: account.id_token }),
          });

          if (!res.ok) return false; // Rails側で拒否されたらログイン失敗

          const data = await res.json();
          // Railsから返ってきたJWTをuserオブジェクトに一時保存
          user.accessToken = data.access_token;
          return true;
        } catch (e) {
          console.error("Rails Auth Error:", e);
          return false;
        }
      }
      return true;
    },
    // RailsのJWTをCookie(token)に保存
    async jwt({ token, user }: any) {
      if (user) {
        token.accessToken = user.accessToken;
      }
      return token;
    },
    // フロントの useSession で RailsのJWTを使えるようにする
    async session({ session, token }: any) {
      session.accessToken = token.accessToken;
      return session;
    },
  },
});

export { handler as GET, handler as POST };
