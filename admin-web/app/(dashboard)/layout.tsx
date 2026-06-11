import { SidebarInset, SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { Separator } from "@/components/ui/separator";
import { AppSidebar } from "@/components/app-sidebar";
import { requireAdmin } from "@/lib/auth";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const profile = await requireAdmin();

  return (
    <SidebarProvider>
      <AppSidebar
        user={{
          full_name: profile.full_name,
          phone_number: profile.phone_number,
        }}
      />
      <SidebarInset>
        <header className="flex h-14 shrink-0 items-center gap-2 border-b px-4">
          <SidebarTrigger className="-ml-1" />
          <Separator orientation="vertical" className="mr-2 h-4" />
          <span className="text-sm font-medium text-muted-foreground">
            Operations dashboard
          </span>
        </header>
        <main className="flex-1 space-y-6 p-6">{children}</main>
      </SidebarInset>
    </SidebarProvider>
  );
}
