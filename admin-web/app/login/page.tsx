"use client";

import { useActionState } from "react";
import { AlertCircle, HeartPulse, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { login, type LoginState } from "./actions";

export default function LoginPage() {
  const [state, formAction, pending] = useActionState<LoginState, FormData>(
    login,
    null,
  );

  return (
    <main className="flex min-h-svh items-center justify-center bg-background p-6">
      <div className="w-full max-w-sm space-y-6">
        <div className="flex flex-col items-center gap-2">
          <div className="flex size-12 items-center justify-center rounded-xl bg-primary text-primary-foreground">
            <HeartPulse className="size-6" />
          </div>
          <h1 className="text-xl font-semibold tracking-tight">
            CallCare Admin
          </h1>
          <p className="text-sm text-muted-foreground">
            Operations dashboard
          </p>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Sign in</CardTitle>
            <CardDescription>
              Use your admin phone number and password.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form action={formAction} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="phone">Phone number</Label>
                <Input
                  id="phone"
                  name="phone"
                  inputMode="tel"
                  placeholder="99123456"
                  autoComplete="username"
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="password">Password</Label>
                <Input
                  id="password"
                  name="password"
                  type="password"
                  autoComplete="current-password"
                  required
                />
              </div>

              {state?.error ? (
                <div className="flex items-center gap-2 rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2 text-sm text-destructive">
                  <AlertCircle className="size-4 shrink-0" />
                  {state.error}
                </div>
              ) : null}

              <Button type="submit" className="w-full" disabled={pending}>
                {pending ? <Loader2 className="size-4 animate-spin" /> : null}
                Sign in
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
    </main>
  );
}
