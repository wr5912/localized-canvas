import { Session, User } from "@supabase/supabase-js";
import { createClient } from "./server";

export async function verifyUserAuthenticated(): Promise<
    { user: User; session: Session } | undefined
> {
  // 创建一个模拟用户对象
  const mockUser = {
    id: "mock-user-id",
    email: "guest@example.com",
    // 添加其他必需的 User 属性
  } as User;

  const mockSession = {
    access_token: "mock-token",
    // 添加其他必需的 Session 属性
  } as Session;

  return { user: mockUser, session: mockSession };
}
