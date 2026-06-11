"use client";

import { Area, AreaChart, Bar, BarChart, CartesianGrid, XAxis } from "recharts";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
  type ChartConfig,
} from "@/components/ui/chart";
import { formatMnt } from "@/lib/format";

export type MonthlyStat = {
  month: string;
  requests_created: number;
  requests_completed: number;
  revenue_mnt: number;
};

const revenueConfig = {
  revenue_mnt: { label: "Revenue", color: "var(--chart-1)" },
} satisfies ChartConfig;

const requestsConfig = {
  requests_created: { label: "Created", color: "var(--chart-2)" },
  requests_completed: { label: "Completed", color: "var(--chart-1)" },
} satisfies ChartConfig;

function monthLabel(value: string) {
  return new Date(value).toLocaleDateString("en-GB", {
    month: "short",
    year: "2-digit",
  });
}

export function RevenueChart({ data }: { data: MonthlyStat[] }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Revenue</CardTitle>
        <CardDescription>Paid QPay + verified manual transfers, by month</CardDescription>
      </CardHeader>
      <CardContent>
        <ChartContainer config={revenueConfig} className="h-56 w-full">
          <AreaChart data={data} margin={{ left: 12, right: 12 }}>
            <CartesianGrid vertical={false} />
            <XAxis
              dataKey="month"
              tickLine={false}
              axisLine={false}
              tickMargin={8}
              tickFormatter={monthLabel}
            />
            <ChartTooltip
              content={
                <ChartTooltipContent
                  labelFormatter={(value) => monthLabel(String(value))}
                  formatter={(value) => formatMnt(Number(value))}
                />
              }
            />
            <Area
              dataKey="revenue_mnt"
              type="monotone"
              fill="var(--color-revenue_mnt)"
              fillOpacity={0.2}
              stroke="var(--color-revenue_mnt)"
              strokeWidth={2}
            />
          </AreaChart>
        </ChartContainer>
      </CardContent>
    </Card>
  );
}

export function RequestsChart({ data }: { data: MonthlyStat[] }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Requests</CardTitle>
        <CardDescription>Created vs completed, by month</CardDescription>
      </CardHeader>
      <CardContent>
        <ChartContainer config={requestsConfig} className="h-56 w-full">
          <BarChart data={data}>
            <CartesianGrid vertical={false} />
            <XAxis
              dataKey="month"
              tickLine={false}
              axisLine={false}
              tickMargin={8}
              tickFormatter={monthLabel}
            />
            <ChartTooltip
              content={
                <ChartTooltipContent
                  labelFormatter={(value) => monthLabel(String(value))}
                />
              }
            />
            <Bar
              dataKey="requests_created"
              fill="var(--color-requests_created)"
              radius={4}
            />
            <Bar
              dataKey="requests_completed"
              fill="var(--color-requests_completed)"
              radius={4}
            />
          </BarChart>
        </ChartContainer>
      </CardContent>
    </Card>
  );
}
